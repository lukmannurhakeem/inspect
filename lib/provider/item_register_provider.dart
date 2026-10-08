import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:provider/provider.dart';

class ItemRegisterProvider extends ChangeNotifier {
  ItemRegisterProvider(this.jobId);

  final String jobId;

  static const idKeys = ['itemId', 'itemID', 'item_id'];

  static const columnLabels = <String, String>{
    'item': 'Item',
    'description': 'Description',
    'category': 'Category',
    'location': 'Location',
    'status': 'Status',
    'inspectedOn': 'Inspected On',
    'expiryDate': 'Expiry Date',
  };

  static const _columnSources = <String, String>{
    'item': 'itemNo',
    'description': 'description',
    'category': 'categoryName',
    'location': 'detailedLocation',
    'status': 'status',
    'inspectedOn': 'firstUseDate',
    'expiryDate': 'expiryDateTimeStamp',
  };

  static const _searchKeys = [
    'itemNo',
    'description',
    'categoryName',
    'detailedLocation',
  ];

  final Set<String> _hiddenColumns = {};
  List<Map<String, dynamic>> _items = [];
  Set<int> _selected = {};
  String _query = '';
  bool _isLoading = false;
  bool _isSyncing = false;
  bool _fromCache = false;
  bool _disposed = false;
  DateTime? _lastSyncTime;
  int _uploadCount = 0;
  int _failCount = 0;
  String? _uploadError;

  bool get hasItems => _items.isNotEmpty;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  bool get isLoadedFromCache => _fromCache;
  bool get hasSynced => _lastSyncTime != null;
  String get query => _query;
  Set<int> get selectedRows => _selected;
  int get uploadCount => _uploadCount;
  int get failCount => _failCount;
  String? get uploadError => _uploadError;
  int get pendingCount => _items.where(isUploadable).length;

  String? get lastSyncLabel {
    final t = _lastSyncTime;
    if (t == null) return null;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  List<String> get activeColumns =>
      columnLabels.keys.where(isColumnVisible).toList();

  List<Map<String, dynamic>> get filteredItems {
    final q = _query.toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where(
          (item) => _searchKeys.any(
            (k) => (item[k]?.toString() ?? '').toLowerCase().contains(q),
      ),
    )
        .toList();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void setQuery(String value) {
    if (value == _query) return;
    _query = value;
    _selected = {};
    notifyListeners();
  }

  void toggleRow(int index, bool selected) {
    selected ? _selected.add(index) : _selected.remove(index);
    notifyListeners();
  }

  void toggleAll(bool selected, int length) {
    _selected = selected ? {for (var i = 0; i < length; i++) i} : {};
    notifyListeners();
  }

  bool isColumnVisible(String key) => !_hiddenColumns.contains(key);

  void setColumnVisible(String key, bool visible) {
    visible ? _hiddenColumns.remove(key) : _hiddenColumns.add(key);
    notifyListeners();
  }

  Future<void> loadLocal() async {
    _isLoading = true;
    notifyListeners();
    try {
      _setItems(await _readMerged());
    } catch (e) {
      debugPrint('loadLocal failed: $e');
      _setItems([]);
    }
    _isLoading = false;
    _fromCache = true;
    notifyListeners();
  }

  Future<bool> sync(BuildContext context) async {
    final jobProvider = context.read<JobProvider>();
    if (!await _isOnline()) {
      await loadLocal();
      return false;
    }

    _isSyncing = true;
    _uploadCount = _failCount = 0;
    _uploadError = null;
    notifyListeners();

    try {
      final uploaded = await _uploadPending(context, jobProvider);
      await _pullServer(context, jobProvider, uploaded);
      _setItems(await _readMerged());
      _lastSyncTime = DateTime.now();
      _fromCache = false;
      return true;
    } catch (e) {
      debugPrint('sync failed: $e');
      await loadLocal();
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  String buildCsv() {
    final list = filteredItems;
    final columns = activeColumns;
    final indexes = _selected.where((i) => i < list.length).toList()..sort();
    final rows = [
      columns.map((k) => columnLabels[k]!),
      for (final i in indexes) columns.map((k) => cellValue(list[i], k)),
    ];
    return rows.map((r) => r.map(_escape).join(',')).join('\n');
  }

  void _setItems(List<Map<String, dynamic>> items) {
    _items = items;
    _selected = {};
  }

  Future<bool> _isOnline() async => (await Connectivity().checkConnectivity())
      .any((r) => r != ConnectivityResult.none);

  Future<List<Map<String, dynamic>>> _readMerged() async {
    final buckets = await Future.wait([
      JobItemStorage.getJobItems(jobId),
      JobItemStorage.getPendingItems(jobId),
      JobItemStorage.getJobDrafts(jobId),
    ]);
    final seen = <String>{};
    return [
      for (final item in buckets.expand((b) => b))
        if (idOf(item).isEmpty || seen.add(idOf(item))) item,
    ];
  }

  Future<Map<String, Map<String, dynamic>>> _uploadPending(
      BuildContext context,
      JobProvider jobProvider,
      ) async {
    final buckets = await Future.wait([
      JobItemStorage.getPendingItems(jobId),
      JobItemStorage.getJobDrafts(jobId),
    ]);
    final seen = <String>{};
    final queue = [
      for (final item in buckets.expand((b) => b))
        if (isUploadable(item) && (idOf(item).isEmpty || seen.add(idOf(item))))
          item,
    ];

    final uploaded = <String, Map<String, dynamic>>{};
    for (final item in queue) {
      final id = idOf(item);
      try {
        final result = await jobProvider.submitJobItemFromMap(
          context,
          jobId,
          item,
        );
        final queued = result['queued'] == true;
        if (result['success'] == true && !queued) {
          _uploadCount++;
          if (id.isNotEmpty) {
            await JobItemStorage.markItemAsSubmitted(jobId, id);
            uploaded[id] = {...item, 'status': 'submitted', 'isPending': false};
          }
        } else {
          _fail(
            result['error'] ??
                result['message'] ??
                (queued ? 'Queued — no connection' : 'Rejected by server'),
          );
        }
      } catch (e) {
        _fail(e);
      }
    }
    return uploaded;
  }

  Future<void> _pullServer(
      BuildContext context,
      JobProvider jobProvider,
      Map<String, Map<String, dynamic>> uploaded,
      ) async {
    try {
      await jobProvider.fetchJobRegisterModel(context, jobId);
    } catch (_) {
      return;
    }
    final server = jobProvider.jobItems.map(toMap).toList();
    if (server.isEmpty) return;
    final serverIds = server.map(idOf).toSet();
    await JobItemStorage.saveJobItems(jobId, [
      ...server,
      for (final e in uploaded.entries)
        if (!serverIds.contains(e.key)) e.value,
    ]);
  }

  void _fail(Object error) {
    _failCount++;
    _uploadError = error.toString();
  }

  static bool isUploadable(Map<String, dynamic> item) =>
      (item['status'] ?? '').toString().toLowerCase() == 'pending_submission' ||
          item['isPending'] == true;

  static String text(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k]?.toString().trim() ?? '';
      if (v.isNotEmpty) return v;
    }
    return '';
  }

  static String idOf(Map<String, dynamic> data) => text(data, idKeys);

  static String value(Map<String, dynamic> data, String key) {
    final v = data[key]?.toString() ?? '';
    return v.isEmpty ? '-' : v;
  }

  static String status(Map<String, dynamic> data) =>
      (data['status'] ?? 'draft').toString().toLowerCase();

  static String cellValue(Map<String, dynamic> data, String column) =>
      column == 'status'
          ? status(data)
          : value(data, _columnSources[column] ?? column);

  static List<Map<String, dynamic>> reports(Map<String, dynamic> data) {
    final raw = data['reports'];
    return raw is List
        ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
  }

  static String _escape(String field) => field.contains(RegExp(r'[",\n]'))
      ? '"${field.replaceAll('"', '""')}"'
      : field;

  static Map<String, dynamic> _alias(List<String> keys, Object? value) => {
    for (final k in keys) k: value,
  };

  static Item toItem(Map<String, dynamic> data) => Item(
    itemId: idOf(data),
    itemNo: text(data, ['itemNo', 'item_no']),
    description: text(data, ['description', 'ItemDescription']),
    categoryId: text(data, ['categoryId', 'categoryID', 'category_id']),
    locationId: text(data, ['locationId', 'locationID', 'location_id']),
    detailedLocation: text(data, [
      'detailedLocation',
      'DetailedLocation',
      'detailed_location',
      'ItemLocation',
    ]),
    status: text(data, ['status']),
    rfidNo: text(data, ['rfidNo', 'RFIDNo', 'rfid_no']),
    manufacturer: text(data, ['manufacturer']),
    swl: text(data, ['swl']),
  );

  static Map<String, dynamic> toMap(Item item) {
    String date(DateTime? d) => d?.toIso8601String().split('T').first ?? '';

    final Map<dynamic, dynamic> custom = item.customFields ?? {};

    String pick(List<String> keys) {
      for (final k in keys) {
        final v = custom[k]?.toString();
        if (v != null) return v;
      }
      return '';
    }

    final categoryId = item.categoryId ?? '';
    final categoryName = pick(['categoryName']);
    final detailedLocation = item.detailedLocation ?? '';
    final manufacturerAddress = item.manufacturerAddress ?? '';
    final expiry = date(item.expiryDateTimeStamp);

    final map = <String, dynamic>{
      ..._alias(idKeys, item.itemId ?? ''),
      'itemNo': item.itemNo ?? '',
      'description': item.description ?? '',
      'archived': (item.archived ?? false).toString(),
      'status': item.status ?? 'submitted',
      ..._alias(['categoryId', 'categoryID', 'category_id'], categoryId),
      'categoryName': categoryName.isNotEmpty ? categoryName : categoryId,
      ..._alias([
        'locationId',
        'locationID',
        'location_id',
      ], item.locationId ?? ''),
      ..._alias([
        'detailedLocation',
        'detailed_location',
        'ItemLocation',
      ], detailedLocation),
      ..._alias(['rfidNo', 'RFIDNo', 'rfid_no'], item.rfidNo ?? ''),
      'manufacturer': item.manufacturer ?? '',
      ..._alias([
        'manufacturerAddress',
        'manufacturer_address',
      ], manufacturerAddress),
      ..._alias([
        'manufacturerDate',
        'manufacture_date',
      ], date(item.manufacturerDate)),
      ..._alias(['firstUseDate', 'first_use_date'], date(item.firstUseDate)),
      ..._alias(['expiryDateTimeStamp', 'expiryDate', 'expiry_date'], expiry),
      'swl': item.swl ?? '',
      ..._alias(['photoReference', 'photo_reference'], item.photoReference ?? ''),
      ..._alias([
        'standardReference',
        'standard_reference',
      ], item.standardReference ?? ''),
      ..._alias(['internalNotes', 'internal_notes'], item.internalNotes ?? ''),
      'customerName': pick(['customerName', 'customer']),
      'siteName': pick(['siteName', 'site']),
      'applicableCode': pick(['applicableCode', 'ApplicableCode']),
      'reports': custom['reports'] ?? [],
    };

    for (final e in custom.entries) {
      if (e.key != 'itemData') {
        map.putIfAbsent(e.key.toString(), () => e.value?.toString() ?? '');
      }
    }

    final data = custom['itemData'];
    if (data is Map) {
      data.forEach((k, v) {
        final s = v?.toString() ?? '';
        if (s.isNotEmpty && (map[k]?.toString() ?? '').isEmpty) {
          map[k.toString()] = s;
        }
      });
    }

    return map;
  }
}