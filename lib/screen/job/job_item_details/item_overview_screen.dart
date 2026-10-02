import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/services/picker_storage_service.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_date_picker_input.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:inspect/widget/file_upload_controller.dart';
import 'package:provider/provider.dart';

class ItemOverviewScreen extends StatefulWidget {
  final Item? item;
  final Map<String, dynamic>? itemMap;

  final String jobId;

  final bool isEditMode;
  final VoidCallback? onSaved;

  const ItemOverviewScreen({
    super.key,
    this.item,
    this.itemMap,
    required this.jobId,
    this.isEditMode = false,
    this.onSaved,
  }) : assert(
         item != null || itemMap != null,
         'Either item or itemMap must be supplied',
       );

  @override
  State<ItemOverviewScreen> createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen> {
  List<Map<String, dynamic>> _customFields = [];
  final Map<String, TextEditingController> _fieldControllers = {};
  final Map<String, FileUploadController> _fileUploadControllers = {};

  /// True while fetching the item detail from the API.
  bool _isFetchingDetail = false;

  /// True while loading category fields from local storage.
  bool _isLoadingFields = false;

  bool _isSaving = false;

  late final Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _data = _buildDataMap();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1️⃣ Fetch full item detail from the API (includes `itemData` dynamic
      //    fields such as "Comment", "Is it safe?", "Photo Reference").
      await _fetchAndMergeItemDetail();
      // 2️⃣ Load category field definitions and prefill controllers.
      _loadFields();
    });
  }

  @override
  void dispose() {
    for (final c in _fieldControllers.values) {
      c.dispose();
    }
    for (final c in _fileUploadControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Fetch & merge API item detail ──────────────────────────────────────────

  /// Calls GET /api/v1/jobitems/detail/:itemId and merges the response into
  /// [_data] so that every field — including the dynamic `itemData` map
  /// (e.g. "Comment", "Is it safe ?", "Photo Reference") — is available
  /// before the category fields are rendered.
  Future<void> _fetchAndMergeItemDetail() async {
    if (!mounted) return;

    final itemId =
        [_data['itemId'], _data['itemID'], _data['item_id']]
            .firstWhere(
              (v) => v != null && v.toString().isNotEmpty,
              orElse: () => '',
            )
            .toString();

    if (itemId.isEmpty) {
      debugPrint(
        '⚠️ ItemOverviewScreen._fetchAndMergeItemDetail: no itemId — skipping',
      );
      return;
    }

    setState(() => _isFetchingDetail = true);

    try {
      final detail = await context.read<JobProvider>().fetchJobItemDetail(
        context,
        itemId,
      );

      if (detail == null || !mounted) return;

      // ── Merge top-level fields ────────────────────────────────────────────
      // API response always wins over the locally-cached data so the screen
      // always reflects the latest server values.
      detail.forEach((key, value) {
        if (key == 'itemData') return; // handled separately below

        final str = value?.toString() ?? '';

        // Always write the value, even empty strings, so null API fields
        // (e.g. rfidNo: null) correctly overwrite stale local data.
        _data[key] = str;

        // Keep all common key-aliases in sync.
        switch (key) {
          case 'itemID':
            _data['itemId'] = str;
            _data['item_id'] = str;
            break;
          case 'itemId':
            _data['itemID'] = str;
            _data['item_id'] = str;
            break;
          case 'jobID':
            // Never overwrite jobId from widget — jobId comes from the parent.
            break;
          case 'description':
            _data['ItemDescription'] = str;
            break;
          case 'detailedLocation':
            _data['detailed_location'] = str;
            _data['ItemLocation'] = str;
            break;
          case 'categoryID':
            _data['categoryId'] = str;
            _data['category_id'] = str;
            break;
          case 'categoryName':
            // keep as-is; already written above
            break;
          case 'rfidNo':
            _data['RFIDNo'] = str;
            _data['rfid_no'] = str;
            break;
          case 'expiryDateTimeStamp':
            _data['expiryDate'] = str;
            _data['expiry_date'] = str;
            break;
          case 'firstUseDate':
            _data['first_use_date'] = str;
            break;
          case 'manufacturerDate':
            _data['manufacture_date'] = str;
            break;
          case 'manufacturerAddress':
            _data['manufacturer_address'] = str;
            break;
        }
      });

      // Always keep widget.jobId as the canonical jobId — never let the API
      // response overwrite it (the item's jobID field is the server ID, which
      // is the same value, but being explicit prevents edge-cases).
      _data['jobId'] = widget.jobId;
      _data['jobID'] = widget.jobId;
      _data['job_id'] = widget.jobId;

      // ── Spread itemData dynamic fields ────────────────────────────────────
      // The API returns custom category fields inside an `itemData` object:
      //   "itemData": { "Comment": "Failed", "Is it safe ?": "true", ... }
      // We spread these directly into _data under their original key names so
      // that _prefillFromData() and _buildFallbackFields() can pick them up.
      final itemData = detail['itemData'];
      if (itemData is Map<String, dynamic>) {
        itemData.forEach((key, value) {
          if (value != null) _data[key] = value.toString();
        });
        debugPrint(
          '✅ _fetchAndMergeItemDetail: merged ${itemData.length} itemData '
          'fields for item $itemId',
        );
      }

      debugPrint(
        '✅ _fetchAndMergeItemDetail: total _data keys after merge: '
        '${_data.keys.length}',
      );
    } catch (e) {
      debugPrint('❌ _fetchAndMergeItemDetail error: $e');
    } finally {
      if (mounted) setState(() => _isFetchingDetail = false);
    }
  }

  // ── Normalise data source ──────────────────────────────────────────────────

  Map<String, dynamic> _buildDataMap() {
    if (widget.item != null) {
      return _itemToFullMap(widget.item!);
    }

    final raw = Map<String, dynamic>.from(widget.itemMap!);

    Item? providerItem;
    try {
      providerItem = context.read<JobProvider>().currentItem;
    } catch (_) {}

    String strRaw(List<String> keys) {
      for (final k in keys) {
        final v = (raw[k] ?? '').toString().trim();
        if (v.isNotEmpty) return v;
      }
      return '';
    }

    final fromMap = <String, dynamic>{
      ...raw,
      'itemId': strRaw(['itemId', 'itemID', 'item_id']),
      'jobId': widget.jobId,
      'itemNo': strRaw(['itemNo', 'item_no']),
      'description': strRaw(['description', 'ItemDescription']),
      'archived': strRaw(['archived']),
      'rfidNo': strRaw(['rfidNo', 'RFIDNo', 'rfid_no']),
      'RFIDNo': strRaw(['rfidNo', 'RFIDNo', 'rfid_no']),
      'categoryId': strRaw(['categoryId', 'categoryID', 'category_id']),
      'categoryName': strRaw([
        'categoryName',
        'category_name',
        'categoryId',
        'categoryID',
      ]),
      'locationId': strRaw(['locationId', 'locationID', 'location_id']),
      'detailedLocation': strRaw([
        'detailedLocation',
        'detailed_location',
        'ItemLocation',
      ]),
      'ItemLocation': strRaw([
        'detailedLocation',
        'detailed_location',
        'ItemLocation',
      ]),
      'internalNotes': strRaw(['internalNotes', 'internal_notes']),
      'manufacturer': strRaw(['manufacturer']),
      'manufacturerAddress': strRaw([
        'manufacturerAddress',
        'manufacturer_address',
      ]),
      'manufacturerDate': strRaw(['manufacturerDate', 'manufacture_date']),
      'firstUseDate': strRaw(['firstUseDate', 'first_use_date']),
      'expiryDateTimeStamp': strRaw([
        'expiryDateTimeStamp',
        'expiryDate',
        'expiry_date',
      ]),
      'status': strRaw(['status']),
      'swl': strRaw(['swl']),
      'photoReference': strRaw(['photoReference', 'photo_reference']),
      'standardReference': strRaw(['standardReference', 'standard_reference']),
      'customerName': strRaw(['customerName', 'customer_name', 'customer']),
      'siteName': strRaw(['siteName', 'site_name', 'site']),
    };

    if (providerItem != null) {
      final providerMap = _itemToFullMap(providerItem);
      providerMap.forEach((key, providerValue) {
        final existing = (fromMap[key] ?? '').toString().trim();
        final pv = (providerValue ?? '').toString().trim();
        if (existing.isEmpty && pv.isNotEmpty) {
          fromMap[key] = pv;
        }
      });
    }

    return fromMap;
  }

  Map<String, dynamic> _itemToFullMap(Item item) {
    final map = <String, dynamic>{
      'itemId': item.itemId ?? '',
      'itemID': item.itemId ?? '',
      'item_id': item.itemId ?? '',
      'jobId': widget.jobId,
      'jobID': widget.jobId,

      'itemNo': item.itemNo ?? '',
      'description': item.description ?? '',
      'ItemDescription': item.description ?? '',
      'archived': (item.archived ?? false).toString(),
      'status': item.status ?? '',

      'categoryId': item.categoryId ?? '',
      'categoryID': item.categoryId ?? '',
      'category_id': item.categoryId ?? '',
      'categoryName':
          (item.customFields?['categoryName']?.toString().isNotEmpty == true)
              ? item.customFields!['categoryName'].toString()
              : item.categoryId ?? '',

      'locationId': item.locationId ?? '',
      'locationID': item.locationId ?? '',
      'location_id': item.locationId ?? '',
      'detailedLocation': item.detailedLocation ?? '',
      'detailed_location': item.detailedLocation ?? '',
      'ItemLocation': item.detailedLocation ?? '',

      'rfidNo': item.rfidNo ?? '',
      'RFIDNo': item.rfidNo ?? '',
      'rfid_no': item.rfidNo ?? '',

      'manufacturer': item.manufacturer ?? '',
      'manufacturerAddress': item.manufacturerAddress ?? '',
      'manufacturer_address': item.manufacturerAddress ?? '',
      'manufacturerDate':
          item.manufacturerDate?.toIso8601String().split('T').first ?? '',
      'manufacture_date':
          item.manufacturerDate?.toIso8601String().split('T').first ?? '',

      'firstUseDate':
          item.firstUseDate?.toIso8601String().split('T').first ?? '',
      'first_use_date':
          item.firstUseDate?.toIso8601String().split('T').first ?? '',
      'expiryDateTimeStamp':
          item.expiryDateTimeStamp?.toIso8601String().split('T').first ?? '',
      'expiryDate':
          item.expiryDateTimeStamp?.toIso8601String().split('T').first ?? '',
      'expiry_date':
          item.expiryDateTimeStamp?.toIso8601String().split('T').first ?? '',

      'swl': item.swl ?? '',
      'photoReference': item.photoReference ?? '',
      'photo_reference': item.photoReference ?? '',
      'standardReference': item.standardReference ?? '',
      'standard_reference': item.standardReference ?? '',
      'internalNotes': item.internalNotes ?? '',
      'internal_notes': item.internalNotes ?? '',

      'customerName':
          item.customFields?['customerName']?.toString() ??
          item.customFields?['customer']?.toString() ??
          '',
      'siteName':
          item.customFields?['siteName']?.toString() ??
          item.customFields?['site']?.toString() ??
          '',
      'applicableCode':
          item.customFields?['applicableCode']?.toString() ??
          item.customFields?['ApplicableCode']?.toString() ??
          '',
    };

    if (item.customFields != null) {
      for (final entry in item.customFields!.entries) {
        if (!map.containsKey(entry.key)) {
          map[entry.key] = entry.value?.toString() ?? '';
        }
      }
    }

    return map;
  }

  // ── Load fields ────────────────────────────────────────────────────────────

  Future<void> _loadFields() async {
    if (!mounted) return;
    setState(() => _isLoadingFields = true);

    try {
      final categoryProvider = context.read<CategoryProvider>();

      final categoryId =
          _data['categoryId']?.toString().isNotEmpty == true
              ? _data['categoryId'].toString()
              : (_data['categoryID']?.toString() ?? '');

      if (categoryId.isNotEmpty) {
        await categoryProvider.loadFieldsFromLocalStorage(categoryId);
        final fields = categoryProvider.getFieldsAsJson();

        if (mounted && fields.isNotEmpty) {
          setState(() {
            _customFields = fields;
            _initializeControllers();
            _prefillFromData();
            _isLoadingFields = false;
          });

          context.read<JobProvider>().fetchCustomers(context);
          context.read<SiteProvider>().fetchSite(context);
          return;
        }
      }

      if (mounted) {
        setState(() {
          _customFields = _buildFallbackFields();
          _initializeControllers();
          _prefillFromData();
          _isLoadingFields = false;
        });
      }
    } catch (e) {
      debugPrint('❌ ItemOverviewScreen: Error loading fields: $e');
      if (mounted) {
        setState(() {
          _customFields = _buildFallbackFields();
          _initializeControllers();
          _prefillFromData();
          _isLoadingFields = false;
        });
      }
    }
  }

  // ── Initialize controllers ─────────────────────────────────────────────────

  void _initializeControllers() {
    for (final c in _fieldControllers.values) {
      c.dispose();
    }
    _fieldControllers.clear();
    for (final c in _fileUploadControllers.values) {
      c.dispose();
    }
    _fileUploadControllers.clear();

    for (final field in _customFields) {
      final fieldId = field['id'] as String;
      final fieldType = (field['fieldType'] as String?) ?? 'Text';
      final labelText = (field['labelText'] as String? ?? '').toLowerCase();
      final defaultValue = (field['defaultValue'] as String?) ?? '';

      if (fieldType == 'ItemNo' || labelText.contains('item no')) continue;

      if (fieldType == 'File') {
        _fileUploadControllers[fieldId] = FileUploadController();
      } else {
        _fieldControllers[fieldId] = TextEditingController(text: defaultValue);
      }
    }
  }

  // ── Prefill from data map ──────────────────────────────────────────────────

  void _prefillFromData() {
    String v(String key) => (_data[key] ?? '').toString();

    for (final field in _customFields) {
      final fieldId = field['id'] as String;
      final fieldName = (field['name'] as String?) ?? '';
      final fieldType = (field['fieldType'] as String?) ?? 'Text';
      final labelText = (field['labelText'] as String? ?? '').toLowerCase();

      if (fieldType == 'File') continue;
      if (fieldType == 'ItemNo' || labelText.contains('item no')) continue;

      final controller = _fieldControllers[fieldId];
      if (controller == null) continue;

      String value = v(fieldName);

      if (value.isEmpty) {
        if (fieldType == 'ItemDescription' ||
            labelText.contains('description')) {
          value = v('description');
        } else if (fieldType == 'ItemLocation' ||
            fieldType == 'DetailedLocation' ||
            fieldType == 'Location' ||
            labelText.contains('location')) {
          value =
              v('detailedLocation').isNotEmpty
                  ? v('detailedLocation')
                  : v('detailed_location');
        } else if (fieldType == 'ItemCategory' ||
            labelText.contains('category')) {
          value = v('categoryName');
        } else if (fieldType == 'RFIDNo' || labelText.contains('rfid')) {
          value = v('rfidNo').isNotEmpty ? v('rfidNo') : v('RFIDNo');
        } else if (labelText.contains('manufacturer address') ||
            labelText.contains('manufactureraddress')) {
          value = v('manufacturerAddress');
        } else if (labelText.contains('manufacturer')) {
          value = v('manufacturer');
        } else if (labelText.contains('swl')) {
          value = v('swl');
        } else if (labelText.contains('inspected') ||
            labelText.contains('first use')) {
          value = v('firstUseDate');
        } else if (labelText.contains('expiry') ||
            labelText.contains('expiration')) {
          value = v('expiryDateTimeStamp');
        } else if (fieldType == 'Customer' || labelText.contains('customer')) {
          value =
              v('customerName').isNotEmpty ? v('customerName') : v('customer');
        } else if (fieldType == 'SiteID' || labelText.contains('site')) {
          value = v('siteName').isNotEmpty ? v('siteName') : v('site');
        } else if (labelText.contains('archived')) {
          value = v('archived');
        } else if (labelText.contains('photo')) {
          value = v('photoReference');
        } else if (labelText.contains('standard') ||
            labelText.contains('reference')) {
          value = v('standardReference');
        } else if (labelText.contains('internal note') ||
            labelText.contains('internalnote')) {
          value = v('internalNotes');
        } else if (labelText.contains('manufacture date') ||
            labelText.contains('manufacturedate')) {
          value = v('manufacturerDate');
        } else if (labelText.contains('applicable code') ||
            labelText.contains('applicablecode')) {
          value = v('applicableCode');
        }
      }

      // Last-resort: case-insensitive key match
      if (value.isEmpty) {
        final lowerName = fieldName.toLowerCase();
        for (final entry in _data.entries) {
          if (entry.key.toLowerCase() == lowerName) {
            value = (entry.value ?? '').toString();
            if (value.isNotEmpty) break;
          }
        }
      }

      if (value.isNotEmpty) {
        controller.text = value;
      }
    }

    debugPrint(
      '✅ ItemOverviewScreen: Pre-filled ${_fieldControllers.length} fields '
      'for item ${_data['itemNo'] ?? _data['itemId']}',
    );
  }

  // ── Fallback fields ────────────────────────────────────────────────────────
  //
  // When no category field definitions are available, we build a field list
  // directly from _data.  This now also picks up any keys that were spread
  // from the API `itemData` object (e.g. "Comment", "Is it safe ?").

  List<Map<String, dynamic>> _buildFallbackFields() {
    const skipKeys = {
      'jobId',
      'jobID',
      'job_id',
      'categoryID',
      'categoryId',
      'category_id',
      'itemId',
      'itemID',
      'item_id',
      'savedAt',
      'queuedAt',
      'submittedAt',
      'updatedAt',
      'retryCount',
      'errorMessage',
      'isPending',
      'status',
      // API-only keys that are not useful as display fields
      'canInspectItem',
      'isActive',
      'isApproved',
      'locationID',
      'locationId',
      'location_id',
    };

    const labels = {
      'itemNo': 'Item No',
      'item_no': 'Item No',
      'description': 'Description',
      'archived': 'Archived',
      'rfidNo': 'RFID No',
      'RFIDNo': 'RFID No',
      'categoryName': 'Category',
      'category_name': 'Category',
      'locationId': 'Location',
      'locationName': 'Location',
      'detailedLocation': 'Detailed Location',
      'detailed_location': 'Detailed Location',
      'internalNotes': 'Internal Notes',
      'internal_notes': 'Internal Notes',
      'externalNotes': 'External Notes',
      'external_notes': 'External Notes',
      'manufacturer': 'Manufacturer',
      'manufacturerAddress': 'Manufacturer Address',
      'manufacturer_address': 'Manufacturer Address',
      'manufacturerDate': 'Manufacture Date',
      'manufacture_date': 'Manufacture Date',
      'firstUseDate': 'First Use Date',
      'first_use_date': 'First Use Date',
      'expiryDateTimeStamp': 'Expiry Date',
      'swl': 'SWL',
      'photoReference': 'Photo Reference',
      'photo_reference': 'Photo Reference',
      'standardReference': 'Standard & Reference',
      'standard_reference': 'Standard & Reference',
      'customerName': 'Customer',
      'siteName': 'Site',
    };

    const dateKeys = {
      'manufacturerDate',
      'manufacture_date',
      'firstUseDate',
      'first_use_date',
      'expiryDateTimeStamp',
    };

    const orderedKeys = [
      'itemNo',
      'description',
      'categoryName',
      'rfidNo',
      'archived',
      'customerName',
      'siteName',
      'locationId',
      'detailedLocation',
      'manufacturer',
      'manufacturerAddress',
      'manufacturerDate',
      'firstUseDate',
      'expiryDateTimeStamp',
      'swl',
      'photoReference',
      'standardReference',
      'internalNotes',
    ];

    final fields = <Map<String, dynamic>>[];
    final seen = <String>{};

    // Add well-known fields first, in the preferred display order.
    for (final key in orderedKeys) {
      if (skipKeys.contains(key)) continue;
      if (!_data.containsKey(key)) continue;
      seen.add(key);
      fields.add({
        'id': key,
        'name': key,
        'labelText': labels[key] ?? _formatLabel(key),
        'fieldType': dateKeys.contains(key) ? 'Date' : 'Text',
        'required': false,
        'defaultValue': (_data[key] ?? '').toString(),
      });
    }

    // Then add any remaining _data keys — this includes keys spread from
    // `itemData` (e.g. "Comment", "Is it safe ?", "Photo Reference").
    for (final entry in _data.entries) {
      if (skipKeys.contains(entry.key)) continue;
      if (seen.contains(entry.key)) continue;
      if (entry.key.startsWith('_')) continue;

      // Skip alias duplicates (e.g. keep 'detailedLocation', skip 'ItemLocation')
      final lowerKey = entry.key.toLowerCase().replaceAll(RegExp(r'[_\s]'), '');
      final isDuplicate = seen.any(
        (s) => s.toLowerCase().replaceAll(RegExp(r'[_\s]'), '') == lowerKey,
      );
      if (isDuplicate) continue;

      seen.add(entry.key);
      fields.add({
        'id': entry.key,
        'name': entry.key,
        'labelText': labels[entry.key] ?? _formatLabel(entry.key),
        'fieldType': dateKeys.contains(entry.key) ? 'Date' : 'Text',
        'required': false,
        'defaultValue': (entry.value ?? '').toString(),
      });
    }

    return fields;
  }

  String _formatLabel(String key) {
    final spaced = key.replaceAll('_', ' ');
    final readable = spaced.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    );
    return readable.isEmpty
        ? key
        : readable[0].toUpperCase() + readable.substring(1);
  }

  // ── Navigate to edit ───────────────────────────────────────────────────────

  Future<void> _navigateToEditItem() async {
    final categoryId =
        [_data['categoryId'], _data['categoryID'], _data['category_id']]
            .firstWhere(
              (v) => v != null && v.toString().isNotEmpty,
              orElse: () => '',
            )
            .toString();

    final categoryName =
        [_data['categoryName'], _data['category_name']]
            .firstWhere(
              (v) => v != null && v.toString().isNotEmpty,
              orElse: () => categoryId,
            )
            .toString();

    final preloadedFields =
        _customFields.map((f) => Map<String, dynamic>.from(f)).toList();

    final existingItem = _data.map((k, v) => MapEntry(k, v?.toString() ?? ''));

    existingItem.addAll({
      'itemId':
          existingItem['itemId'] ??
          existingItem['itemID'] ??
          existingItem['item_id'] ??
          '',
      'itemID': existingItem['itemId'] ?? '',
      'item_id': existingItem['itemId'] ?? '',
      'jobId': widget.jobId,
      'jobID': widget.jobId,
      'job_id': widget.jobId,
      'rfidNo':
          existingItem['rfidNo'] ??
          existingItem['RFIDNo'] ??
          existingItem['rfid_no'] ??
          '',
      'RFIDNo': existingItem['rfidNo'] ?? '',
      'description':
          existingItem['description'] ?? existingItem['ItemDescription'] ?? '',
      'ItemDescription': existingItem['description'] ?? '',
      'detailedLocation':
          existingItem['detailedLocation'] ??
          existingItem['detailed_location'] ??
          existingItem['ItemLocation'] ??
          '',
      'detailed_location': existingItem['detailedLocation'] ?? '',
      'ItemLocation': existingItem['detailedLocation'] ?? '',
      'categoryId': categoryId,
      'categoryID': categoryId,
      'category_id': categoryId,
      'categoryName': categoryName,
      'customerName':
          existingItem['customerName'] ?? existingItem['customer'] ?? '',
      'siteName': existingItem['siteName'] ?? existingItem['site'] ?? '',
    });

    debugPrint(
      '🔍 _navigateToEditItem → jobId: ${widget.jobId} | '
      'itemId: ${existingItem['itemId']} | '
      'categoryId: $categoryId | '
      'fields: ${preloadedFields.length}',
    );

    final categoryItem = CategoryItem(
      id: categoryId,
      name: categoryName.isNotEmpty ? categoryName : categoryId,
      children: [],
      level: 0,
    );

    await NavigationService().navigateTo(
      NavigationRoutes.jobItemCreateScreen,
      arguments: {
        'jobId': widget.jobId,
        'isEditMode': true,
        'existingItem': existingItem,
        'selectedCategory': categoryItem,
        'preloadedFields': preloadedFields,
      },
    );

    if (mounted) widget.onSaved?.call();
  }

  // ── Save (in-place field edits) ────────────────────────────────────────────

  Future<void> _saveChanges() async {
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      final updatedData = Map<String, dynamic>.from(_data);

      for (final field in _customFields) {
        final fieldId = field['id'] as String;
        final fieldName = (field['name'] as String?) ?? fieldId;
        final fieldType = (field['fieldType'] as String?) ?? 'Text';
        final labelText = (field['labelText'] as String? ?? '').toLowerCase();

        if (fieldType == 'File') continue;
        if (fieldType == 'ItemNo' || labelText.contains('item no')) continue;

        final controller = _fieldControllers[fieldId];
        if (controller == null) continue;

        final value = controller.text.trim();
        updatedData[fieldName] = value;

        if (fieldType == 'ItemDescription' ||
            labelText.contains('description')) {
          updatedData['description'] = value;
        }
        if (fieldType == 'ItemLocation' ||
            fieldType == 'DetailedLocation' ||
            fieldType == 'Location' ||
            labelText.contains('location')) {
          updatedData['detailedLocation'] = value;
        }
        if (labelText.contains('inspected') ||
            labelText.contains('first use')) {
          updatedData['firstUseDate'] = value;
        }
        if (labelText.contains('expiry') || labelText.contains('expiration')) {
          updatedData['expiryDateTimeStamp'] = value;
        }
        if (fieldType == 'Customer' || labelText.contains('customer')) {
          updatedData['customerName'] = value;
        }
        if (fieldType == 'SiteID' || labelText.contains('site')) {
          updatedData['siteName'] = value;
        }
      }

      final jobId = widget.jobId;
      final itemId =
          (updatedData['itemId'] ??
                  updatedData['itemID'] ??
                  updatedData['item_id'] ??
                  '')
              .toString();

      if (jobId.isNotEmpty && itemId.isNotEmpty) {
        await JobItemStorage.updateItem(jobId, itemId, updatedData);
        debugPrint('✅ ItemOverviewScreen: Item $itemId updated');
      } else {
        debugPrint(
          '⚠️ ItemOverviewScreen: Missing jobId ($jobId) or itemId ($itemId)',
        );
      }

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Item updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        widget.onSaved?.call();
      }
    } catch (e) {
      debugPrint('❌ ItemOverviewScreen: Error saving: $e');
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to save: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ── Section grouping ───────────────────────────────────────────────────────

  Map<String, List<Map<String, dynamic>>> _groupFieldsBySection() {
    final grouped = <String, List<Map<String, dynamic>>>{
      'Basic Information': [],
      'Location Details': [],
      'Manufacturer Information': [],
      'Other': [],
    };

    for (final field in _customFields) {
      final fieldType = (field['fieldType'] as String?) ?? '';
      final labelText = (field['labelText'] as String? ?? '').toLowerCase();

      if (fieldType == 'ItemNo' || labelText.contains('item no')) continue;

      if (fieldType == 'ItemDescription' ||
          fieldType == 'Customer' ||
          fieldType == 'SiteID' ||
          fieldType == 'ItemCategory' ||
          fieldType == 'ApplicableCode' ||
          fieldType == 'RFIDNo' ||
          labelText.contains('description') ||
          labelText.contains('category') ||
          labelText.contains('rfid') ||
          labelText.contains('archived') ||
          labelText.contains('status') ||
          labelText.contains('customer') ||
          labelText.contains('site') ||
          labelText.contains('applicable code')) {
        grouped['Basic Information']!.add(field);
      } else if (fieldType == 'ItemLocation' ||
          fieldType == 'DetailedLocation' ||
          (fieldType == 'Location' && !labelText.contains('applicable code')) ||
          (labelText.contains('location') &&
              !labelText.contains('applicable code'))) {
        grouped['Location Details']!.add(field);
      } else if (labelText.contains('manufacturer') ||
          labelText.contains('manufacture')) {
        grouped['Manufacturer Information']!.add(field);
      } else {
        grouped['Other']!.add(field);
      }
    }

    grouped.removeWhere((_, v) => v.isEmpty);
    return grouped;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Show a spinner while fetching item detail OR loading category fields.
    if (_isFetchingDetail || _isLoadingFields) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.colors.primary),
            const SizedBox(height: 16),
            Text(
              _isFetchingDetail ? 'Loading item...' : 'Loading fields...',
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ),
      );
    }

    if (_customFields.isEmpty) {
      return Center(
        child: Text(
          'No fields available for this item.',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return context.isTablet
        ? _buildTabletLayout(context)
        : _buildMobileLayout(context);
  }

  Widget _buildMobileLayout(BuildContext context) {
    final grouped = _groupFieldsBySection();
    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.vM,
          ...grouped.entries.map((e) => _buildSection(context, e.key, e.value)),
          context.vM,
          CommonButton(text: 'Edit Item', onPressed: _navigateToEditItem),
          if (widget.isEditMode) ...[
            context.vM,
            CommonButton(
              text: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _saveChanges,
            ),
          ],
          context.vL,
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final grouped = _groupFieldsBySection();
    final allSections = grouped.entries.toList();
    final halfIndex = (allSections.length / 2).ceil();

    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 160,
                  child: CommonButton(
                    text: 'Edit Item',
                    onPressed: _navigateToEditItem,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.vM,
                        ...allSections
                            .take(halfIndex)
                            .map((e) => _buildSection(context, e.key, e.value)),
                      ],
                    ),
                  ),
                ),
                context.hXl,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.vM,
                        ...allSections
                            .skip(halfIndex)
                            .map((e) => _buildSection(context, e.key, e.value)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isEditMode) ...[
            context.vM,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: CommonButton(
                    text: _isSaving ? 'Saving...' : 'Save Changes',
                    onPressed: _isSaving ? null : _saveChanges,
                  ),
                ),
              ],
            ),
          ],
          context.vM,
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String sectionName,
    List<Map<String, dynamic>> fields,
  ) {
    IconData icon = Icons.info_outline;
    if (sectionName == 'Location Details') icon = Icons.location_on;
    if (sectionName == 'Manufacturer Information') icon = Icons.factory;
    if (sectionName == 'Other') icon = Icons.extension;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, sectionName, icon),
        context.vM,
        ...fields.map(
          (field) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildDynamicField(context, field),
          ),
        ),
        context.vL,
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: context.colors.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(BuildContext context, Map<String, dynamic> field) {
    final fieldId = field['id'] as String;
    final labelText = (field['labelText'] as String? ?? '');
    final fieldType = (field['fieldType'] as String?) ?? 'Text';
    final IconData? icon = _getIconForFieldType(fieldType);
    final int maxLines = fieldType == 'Multi-Line Textbox' ? 3 : 1;

    if (fieldType == 'ItemNo' || labelText.toLowerCase().contains('item no')) {
      return const SizedBox.shrink();
    }

    switch (fieldType) {
      case 'Customer':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildCustomerDropdownField(
          context,
          labelText,
          controller,
          icon: icon,
        );

      case 'SiteID':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildSiteDropdownField(
          context,
          labelText,
          controller,
          icon: icon,
        );

      case 'ItemCategory':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildItemCategoryDropdownField(
          context,
          labelText,
          controller,
          icon: icon,
        );

      case 'Date':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildDateField(context, labelText, controller, icon: icon);

      case 'File':
        final fileController = _fileUploadControllers[fieldId];
        if (fileController == null) return const SizedBox.shrink();
        return _buildFileField(context, labelText, fileController, icon: icon);

      case 'Boolean':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildBooleanField(context, labelText, controller, icon: icon);

      case 'Dropdown':
      case 'Override Dropdown':
      case 'Conditional Dropdown':
      case 'Site Dropdown':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildDropdownField(
          context,
          labelText,
          controller,
          field,
          icon: icon,
        );

      case 'Location':
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildLocationField(
          context,
          labelText,
          controller,
          field,
          icon: icon,
        );

      default:
        final controller = _fieldControllers[fieldId];
        if (controller == null) return const SizedBox.shrink();
        return _buildTextRow(
          context,
          labelText,
          controller,
          maxLines: maxLines,
          icon: icon,
          readOnly: !widget.isEditMode,
        );
    }
  }

  Widget _buildTextRow(
    BuildContext context,
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? icon,
    bool readOnly = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: CommonTextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child:
              widget.isEditMode
                  ? CommonDatePickerInput(label: '', controller: controller)
                  : IgnorePointer(
                    child: CommonDatePickerInput(
                      label: '',
                      controller: controller,
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildBooleanField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  label,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child:
                widget.isEditMode
                    ? Checkbox(
                      value: controller.text.toLowerCase() == 'true',
                      onChanged:
                          (value) => setState(
                            () => controller.text = value.toString(),
                          ),
                      activeColor: context.colors.primary,
                    )
                    : IgnorePointer(
                      child: Checkbox(
                        value: controller.text.toLowerCase() == 'true',
                        onChanged: null,
                        activeColor: context.colors.primary,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller,
    Map<String, dynamic> field, {
    IconData? icon,
  }) {
    final rawOptions =
        (field['dropdownOptions'] as List<dynamic>?) ??
        (field['options'] as List<dynamic>?) ??
        [];
    final dropdownItems =
        rawOptions.isEmpty
            ? <String>[]
            : rawOptions.map((e) => e.toString()).toList();

    String? selectedValue = controller.text.isEmpty ? null : controller.text;
    if (selectedValue != null && !dropdownItems.contains(selectedValue)) {
      selectedValue = null;
    }

    if (dropdownItems.isEmpty) {
      return _buildTextRow(
        context,
        label,
        controller,
        icon: icon,
        readOnly: !widget.isEditMode,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child:
              widget.isEditMode
                  ? CommonDropdown<String>(
                    value: selectedValue,
                    items:
                        dropdownItems
                            .map(
                              (o) => DropdownMenuItem<String>(
                                value: o,
                                child: Text(
                                  o,
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: context.colors.primary),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) =>
                            setState(() => controller.text = value ?? ''),
                    borderColor: context.colors.primary.withOpacity(0.3),
                    borderWidth: 1.0,
                    borderRadius: 8.0,
                  )
                  : IgnorePointer(
                    child: CommonDropdown<String>(
                      value: selectedValue,
                      items:
                          dropdownItems
                              .map(
                                (o) => DropdownMenuItem<String>(
                                  value: o,
                                  child: Text(
                                    o,
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary,
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: null,
                      borderColor: context.colors.primary.withOpacity(0.3),
                      borderWidth: 1.0,
                      borderRadius: 8.0,
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildLocationField(
    BuildContext context,
    String label,
    TextEditingController controller,
    Map<String, dynamic> field, {
    IconData? icon,
  }) {
    final rawOptions =
        (field['dropdownOptions'] as List<dynamic>?) ??
        (field['options'] as List<dynamic>?) ??
        [];
    final fieldDefinedLocations = rawOptions.map((e) => e.toString()).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon ?? Icons.location_on_outlined,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child:
              widget.isEditMode
                  ? GestureDetector(
                    onTap:
                        () => _showLocationPickerDialog(
                          controller: controller,
                          fieldDefinedLocations: fieldDefinedLocations,
                        ),
                    child: _locationPickerDisplay(context, controller),
                  )
                  : _locationPickerDisplay(context, controller),
        ),
      ],
    );
  }

  Widget _locationPickerDisplay(
    BuildContext context,
    TextEditingController controller,
  ) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) {
        final hasValue = value.text.trim().isNotEmpty;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  hasValue
                      ? context.colors.primary
                      : context.colors.primary.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(8),
            color:
                hasValue
                    ? context.colors.primary.withOpacity(0.05)
                    : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color:
                    hasValue
                        ? context.colors.primary
                        : context.colors.primary.withOpacity(0.4),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasValue ? value.text : 'No location set',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color:
                        hasValue
                            ? context.colors.primary
                            : context.colors.primary.withOpacity(0.4),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isEditMode)
                Icon(
                  Icons.arrow_drop_down,
                  color: context.colors.primary.withOpacity(0.6),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileField(
    BuildContext context,
    String label,
    FileUploadController controller, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: context.colors.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child:
              widget.isEditMode
                  ? CommonFileUploadInput(
                    controller: controller,
                    enableCamera: true,
                  )
                  : IgnorePointer(
                    child: CommonFileUploadInput(
                      controller: controller,
                      enableCamera: false,
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildCustomerDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, _) {
        final customers = jobProvider.customers;
        String? selectedValue =
            controller.text.isEmpty ? null : controller.text;
        if (selectedValue != null &&
            !customers.any((c) => c.customername == selectedValue)) {
          selectedValue = null;
        }
        return _buildProviderDropdownRow(
          context,
          label: label,
          icon: icon ?? Icons.person,
          selectedValue: selectedValue,
          items:
              customers
                  .where(
                    (c) => c.customername != null && c.customername!.isNotEmpty,
                  )
                  .map((c) => c.customername!)
                  .toList(),
          onChanged: (v) => setState(() => controller.text = v ?? ''),
        );
      },
    );
  }

  Widget _buildSiteDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return Consumer<SiteProvider>(
      builder: (context, siteProvider, _) {
        final sites = siteProvider.sites;
        String? selectedValue =
            controller.text.isEmpty ? null : controller.text;
        if (selectedValue != null &&
            !sites.any((s) => s.siteName == selectedValue)) {
          selectedValue = null;
        }
        return _buildProviderDropdownRow(
          context,
          label: label,
          icon: icon ?? Icons.location_city,
          selectedValue: selectedValue,
          items:
              sites
                  .where((s) => s.siteName != null && s.siteName!.isNotEmpty)
                  .map((s) => s.siteName!)
                  .toList(),
          onChanged: (v) => setState(() => controller.text = v ?? ''),
        );
      },
    );
  }

  Widget _buildItemCategoryDropdownField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final List<CategoryItem> flat = [];
        void flatten(List<CategoryItem> items) {
          for (final item in items) {
            flat.add(item);
            if (item.children.isNotEmpty) flatten(item.children);
          }
        }

        flatten(categoryProvider.filteredCategories);

        String? selectedValue =
            controller.text.isEmpty ? null : controller.text;
        if (selectedValue != null &&
            !flat.any((c) => c.name == selectedValue)) {
          selectedValue = null;
        }
        return _buildProviderDropdownRow(
          context,
          label: label,
          icon: icon ?? Icons.category,
          selectedValue: selectedValue,
          items: flat.map((c) => c.name).toList(),
          onChanged: (v) => setState(() => controller.text = v ?? ''),
        );
      },
    );
  }

  Widget _buildProviderDropdownRow(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String? selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: context.colors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    label,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.hS,
        Expanded(
          flex: 3,
          child:
              widget.isEditMode
                  ? CommonDropdown<String>(
                    value: selectedValue,
                    items:
                        items
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: context.colors.primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: onChanged,
                    borderColor: context.colors.primary.withOpacity(0.3),
                    borderWidth: 1.0,
                    borderRadius: 8.0,
                  )
                  : IgnorePointer(
                    child: CommonDropdown<String>(
                      value: selectedValue,
                      items:
                          items
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: null,
                      borderColor: context.colors.primary.withOpacity(0.3),
                      borderWidth: 1.0,
                      borderRadius: 8.0,
                    ),
                  ),
        ),
      ],
    );
  }

  void _showLocationPickerDialog({
    required TextEditingController controller,
    required List<String> fieldDefinedLocations,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => _LocationPickerDialog(
            fieldDefinedLocations: fieldDefinedLocations,
            initialValue: controller.text,
            storageKey: PickerStorageKey.itemLocation,
            dialogTitle: 'Select Location',
            emptyHint: 'Select or enter location',
            onConfirm: (value, isCustom) async {
              setState(() => controller.text = value);
              if (isCustom) {
                await PickerStorageService.add(
                  PickerStorageKey.itemLocation,
                  value,
                );
              }
            },
          ),
    );
  }

  IconData? _getIconForFieldType(String fieldType) {
    switch (fieldType) {
      case 'Text':
      case 'Multi-Line Textbox':
        return Icons.text_fields;
      case 'Numeric':
      case 'Decimal':
        return Icons.pin;
      case 'Date':
        return Icons.calendar_today;
      case 'Boolean':
        return Icons.check_box_outlined;
      case 'Dropdown':
      case 'Override Dropdown':
      case 'Conditional Dropdown':
      case 'Site Dropdown':
        return Icons.arrow_drop_down_circle;
      case 'File':
        return Icons.attach_file;
      case 'Signature':
        return Icons.edit;
      case 'Colour Picker':
        return Icons.palette;
      case 'ItemNo':
        return Icons.tag;
      case 'ItemDescription':
        return Icons.description;
      case 'Customer':
        return Icons.person;
      case 'SiteID':
        return Icons.location_city;
      case 'ItemCategory':
        return Icons.category;
      case 'ItemLocation':
        return Icons.place;
      case 'Location':
        return Icons.location_on_outlined;
      case 'DetailedLocation':
        return Icons.my_location;
      case 'RFIDNo':
        return Icons.nfc;
      case 'LatestPhoto':
        return Icons.photo_camera;
      case 'ApplicableCode':
        return Icons.gavel_outlined;
      default:
        return Icons.input;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LocationPickerDialog  (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _LocationPickerDialog extends StatefulWidget {
  final List<String> fieldDefinedLocations;
  final String initialValue;
  final String storageKey;
  final String dialogTitle;
  final String emptyHint;
  final void Function(String value, bool isCustom) onConfirm;

  const _LocationPickerDialog({
    required this.fieldDefinedLocations,
    required this.initialValue,
    this.storageKey = PickerStorageKey.itemLocation,
    this.dialogTitle = 'Select Location',
    this.emptyHint = 'Select or enter location',
    required this.onConfirm,
  });

  @override
  State<_LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<_LocationPickerDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customController = TextEditingController();

  List<String> _savedLocations = [];
  bool _isLoading = true;
  List<String> _filteredField = [];
  List<String> _filteredSaved = [];
  List<String> _filteredAll = [];
  String? _selected;

  static const double _listHeight = 240.0;
  static const double _itemHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredField = List.from(widget.fieldDefinedLocations);

    if (widget.initialValue.isNotEmpty &&
        widget.fieldDefinedLocations.contains(widget.initialValue)) {
      _selected = widget.initialValue;
    } else if (widget.initialValue.isNotEmpty) {
      _customController.text = widget.initialValue;
    }

    _searchController.addListener(_onSearch);
    _loadSaved();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    _customController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final saved = await PickerStorageService.getAll(widget.storageKey);
    if (!mounted) return;
    setState(() {
      _savedLocations =
          saved
              .where(
                (loc) =>
                    !widget.fieldDefinedLocations.any(
                      (f) => f.toLowerCase() == loc.toLowerCase(),
                    ),
              )
              .toList();
      _rebuildFiltered(_searchController.text);
      _isLoading = false;
    });
  }

  void _onSearch() => setState(() => _rebuildFiltered(_searchController.text));

  void _rebuildFiltered(String query) {
    final q = query.toLowerCase().trim();
    _filteredField =
        q.isEmpty
            ? List.from(widget.fieldDefinedLocations)
            : widget.fieldDefinedLocations
                .where((l) => l.toLowerCase().contains(q))
                .toList();
    _filteredSaved =
        q.isEmpty
            ? List.from(_savedLocations)
            : _savedLocations
                .where((l) => l.toLowerCase().contains(q))
                .toList();
    final combined =
        <String>{...widget.fieldDefinedLocations, ..._savedLocations}.toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    _filteredAll =
        q.isEmpty
            ? combined
            : combined.where((l) => l.toLowerCase().contains(q)).toList();
  }

  bool get _canConfirm =>
      _customController.text.trim().isNotEmpty || _selected != null;

  void _confirm() {
    final custom = _customController.text.trim();
    if (custom.isNotEmpty) {
      widget.onConfirm(custom, true);
    } else if (_selected != null) {
      widget.onConfirm(_selected!, _savedLocations.contains(_selected));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasAnyList =
        widget.fieldDefinedLocations.isNotEmpty || _savedLocations.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: context.colors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.dialogTitle,
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 40),
              Center(
                child: CircularProgressIndicator(
                  color: context.colors.primary,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(height: 40),
            ] else ...[
              if (hasAnyList)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: _inputDecoration(
                      context,
                      hint: 'Search locations…',
                      prefixIcon: Icons.search,
                    ),
                    style: TextStyle(
                      color: context.colors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              if (hasAnyList) ...[
                const SizedBox(height: 8),
                _buildTabBar(context),
                SizedBox(
                  height: _listHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(
                        context,
                        _filteredField,
                        emptyText: 'No predefined locations',
                      ),
                      _buildList(
                        context,
                        _filteredSaved,
                        emptyText: 'No recently used locations',
                      ),
                      _buildList(
                        context,
                        _filteredAll,
                        emptyText: 'No matches',
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.colors.primary.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'or type your own',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary.withOpacity(0.45),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.colors.primary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _customController,
                  onChanged:
                      (_) => setState(() {
                        if (_customController.text.isNotEmpty) _selected = null;
                      }),
                  decoration: _inputDecoration(
                    context,
                    hint: 'Type a custom location…',
                    prefixIcon: Icons.edit_location_alt_outlined,
                  ),
                  style: TextStyle(color: context.colors.primary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: context.colors.primary.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _customController,
                      builder:
                          (_, __, ___) => ElevatedButton.icon(
                            onPressed: _canConfirm ? _confirm : null,
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: context.colors.primary
                                  .withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: context.colors.primary.withOpacity(0.6),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Predefined'),
          Tab(text: 'Recent'),
          Tab(text: 'All'),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<String> items, {
    required String emptyText,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: context.topology.textTheme.bodySmall?.copyWith(
            color: context.colors.primary.withOpacity(0.4),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemExtent: _itemHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemBuilder: (_, index) {
        final loc = items[index];
        final isSelected = _selected == loc;
        return Material(
          color:
              isSelected
                  ? context.colors.primary.withOpacity(0.08)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap:
                () => setState(() {
                  _selected = loc;
                  _customController.clear();
                }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.location_on : Icons.location_on_outlined,
                    size: 18,
                    color:
                        isSelected
                            ? context.colors.primary
                            : context.colors.primary.withOpacity(0.4),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      loc,
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: context.colors.primary,
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData prefixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: context.colors.primary.withOpacity(0.3)),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: context.colors.primary.withOpacity(0.4),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: context.colors.primary.withOpacity(0.5),
        size: 20,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5),
      ),
    );
  }
}
