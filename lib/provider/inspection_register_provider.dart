import 'package:flutter/foundation.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/storage/job_item_storage.dart';

class InspectionRegisterProvider extends ChangeNotifier {
  InspectionRegisterProvider(this.jobId, this._jobProvider);

  final String jobId;
  final JobProvider _jobProvider;

  static const columnLabels = <String, String>{
    'item': 'Item No',
    'description': 'Description',
    'category': 'Category',
    'location': 'Location',
    'reportNo': 'Report No',
    'reportType': 'Report Type',
    'reportName': 'Report Name',
    'status': 'Status',
    'inspectedOn': 'Inspected On',
    'expiryDate': 'Expiry Date',
    'pdf': 'PDF',
  };

  static const mobileColumns = [
    'item',
    'description',
    'reportNo',
    'reportName',
    'status',
    'inspectedOn',
    'pdf',
  ];

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final Set<String> _hiddenColumns = {};
  List<Map<String, dynamic>> _reports = [];
  Set<int> _selected = {};
  String _query = '';
  String? _error;
  bool _isLoading = false;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get hasReports => _reports.isNotEmpty;
  String? get error => _error;
  String get query => _query;
  Set<int> get selectedRows => _selected;
  int get exportCount => _selected.isEmpty ? filtered.length : _selected.length;

  List<String> get activeColumns =>
      columnLabels.keys.where(isColumnVisible).toList();

  List<Map<String, dynamic>> get filtered {
    final q = _query.toLowerCase();
    if (q.isEmpty) return _reports;
    return _reports
        .where(
          (r) =>
          [
            r['_itemNo'],
            r['_description'],
            r['reportName'],
            r['reportNo'],
            resolveStatus(r),
          ].any((v) => (v?.toString() ?? '').toLowerCase().contains(q)),
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
    _jobProvider.removeListener(_onJobItemsChanged);
    super.dispose();
  }

  void init() {
    if (_jobProvider.jobItems.isNotEmpty) {
      load();
    } else {
      _jobProvider.addListener(_onJobItemsChanged);
    }
  }

  void _onJobItemsChanged() {
    if (_jobProvider.jobItems.isEmpty || _isLoading || _reports.isNotEmpty) {
      return;
    }
    _jobProvider.removeListener(_onJobItemsChanged);
    load();
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

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final items = _uniqueItems();
      final cached = <Map<String, dynamic>>[];
      for (final item in items) {
        try {
          final stored = await JobItemStorage.getItemReports(item.itemId!);
          cached.addAll(
            stored.where(_isSettled).map((e) => _normalize(e, item)),
          );
        } catch (e) {
          debugPrint('cache read failed ${item.itemId}: $e');
        }
      }
      _setReports(cached);
      _isLoading = false;
      notifyListeners();
      _refreshFromApi(items);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Item> _uniqueItems() {
    final seen = <String>{};
    return _jobProvider.jobItems
        .where((i) => (i.itemId ?? '').isNotEmpty && seen.add(i.itemId!))
        .toList();
  }

  Future<void> _refreshFromApi(List<Item> items) async {
    final api = ServiceLocator().apiClient;
    final collected = <Map<String, dynamic>>[];

    for (final item in items) {
      final id = item.itemId!;
      try {
        final response = await api.get(ApiEndpoint.getItemReport(id));
        final data = response.data;
        if (data is! List) continue;

        final server = data
            .whereType<Map<String, dynamic>>()
            .map(_toStored)
            .toList();
        final serverIds = server
            .map((r) => r['reportId'].toString())
            .where((v) => v.isNotEmpty)
            .toSet();
        final offline = (await JobItemStorage.getItemReports(id)).where((l) {
          final localId = l['reportId']?.toString() ?? '';
          return localId.isEmpty || !serverIds.contains(localId);
        });

        final merged = [...server, ...offline];
        await JobItemStorage.saveItemReports(id, merged);
        collected.addAll(
          merged.where(_isSettled).map((e) => _normalize(e, item)),
        );
      } catch (e) {
        debugPrint('api refresh failed $id: $e');
      }
    }

    if (collected.isNotEmpty) {
      _setReports(collected);
      notifyListeners();
    }
  }

  void _setReports(List<Map<String, dynamic>> reports) {
    _reports = reports;
    _selected = {};
  }

  String buildCsv() {
    final list = filtered;
    final columns = activeColumns;
    final rows = _selected.isEmpty
        ? list
        : (_selected.where((i) => i < list.length).toList()..sort()).map(
          (i) => list[i],
    );
    final lines = [
      columns.map((k) => k == 'pdf' ? 'PDF URL' : columnLabels[k]!),
      for (final r in rows) columns.map((k) => cellValue(r, k)),
    ];
    return lines.map((l) => l.map(_escape).join(',')).join('\n');
  }

  static bool _isSettled(Map<String, dynamic> entry) =>
      entry['isPending'] != true;

  static String pick(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k]?.toString() ?? '';
      if (v.trim().isNotEmpty) return v;
    }
    return '';
  }

  static String text(Map<String, dynamic> data, String key) {
    final v = pick(data, [key]);
    return v.isEmpty ? '-' : v;
  }

  static String resolveStatus(Map<String, dynamic> data) {
    final approval = data['approvalStatus']?.toString() ?? '';
    return approval.isNotEmpty
        ? approval
        : data['status']?.toString() ?? 'pending';
  }

  static String formatDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso.isEmpty || iso == 'null' ? '-' : iso;
    return '${d.day.toString().padLeft(2, '0')}-${_months[d.month - 1]}-${d.year}';
  }

  static String cellValue(Map<String, dynamic> data, String column) =>
      switch (column) {
        'item' => text(data, '_itemNo'),
        'description' => text(data, '_description'),
        'category' => text(data, '_categoryId'),
        'location' => text(data, '_locationId'),
        'reportNo' => text(data, 'reportNo'),
        'reportType' => text(data, 'documentCode'),
        'reportName' => text(data, 'reportName'),
        'status' => resolveStatus(data),
        'inspectedOn' => formatDate(
          pick(data, ['inspectedOn', 'createdAt']),
        ),
        'expiryDate' => formatDate(pick(data, ['expiryDate', '_itemExpiryDate'])),
        _ => data['pdfViewUrl']?.toString() ?? '',
      };

  static String _escape(String field) => field.contains(RegExp(r'[",\n]'))
      ? '"${field.replaceAll('"', '""')}"'
      : field;

  static Map<String, dynamic> _toStored(Map<String, dynamic> r) {
    final id = pick(r, ['reportID', 'reportId']);
    final typeId = pick(r, ['reportTypeID', 'reportTypeId']);
    final status = r['status'] ?? '';
    return {
      'reportID': id,
      'reportId': id,
      'reportNo': r['reportNo'] ?? '',
      'reportName': r['reportName'] ?? '',
      'reportTypeID': typeId,
      'reportTypeId': typeId,
      'documentCode': r['documentCode'] ?? '',
      'reportDate': r['reportDate']?.toString() ?? '',
      'createdAt': r['createdAt']?.toString() ?? '',
      'inspectedOn': r['inspectedOn']?.toString() ?? '',
      'status': status,
      'approvalStatus': r['approvalStatus'] ?? status,
      'inspectedBy': r['inspectedBy'] ?? '',
      'expiryDate': pick(r, ['expiryDate', 'ExpiryDate']),
      'pdfUrlView': r['pdfViewUrl'] ?? r['pdfUrlView'] ?? '',
      'pdfUrl': r['pdfDownloadUrl'] ?? r['pdfUrl'] ?? '',
      'isPending': false,
    };
  }

  static Map<String, dynamic> _normalize(Map<String, dynamic> e, Item item) => {
    'reportId': pick(e, ['reportID', 'reportId']),
    'reportNo': pick(e, ['reportNo']),
    'reportName': pick(e, ['reportName']),
    'reportTypeId': pick(e, ['reportTypeID', 'reportTypeId']),
    'documentCode': pick(e, ['documentCode']),
    'status': pick(e, ['status']),
    'approvalStatus': pick(e, ['approvalStatus']),
    'inspectedBy': pick(e, ['inspectedBy']),
    'inspectedOn': pick(e, ['inspectedOn']),
    'reportDate': pick(e, ['reportDate']),
    'createdAt': pick(e, ['createdAt']),
    'expiryDate': pick(e, ['expiryDate']),
    'pdfViewUrl': pick(e, ['pdfUrlView', 'pdfViewUrl']),
    'pdfDownloadUrl': pick(e, ['pdfUrl', 'pdfDownloadUrl']),
    '_itemId': item.itemId ?? '',
    '_itemNo': item.itemNo ?? '',
    '_description': item.description ?? '',
    '_categoryId': item.categoryId ?? '',
    '_locationId': item.locationId ?? '',
    '_itemExpiryDate': item.expiryDateTimeStamp?.toIso8601String() ?? '',
  };
}