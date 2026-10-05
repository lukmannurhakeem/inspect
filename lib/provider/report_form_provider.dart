import 'package:flutter/material.dart';
import 'package:inspect/core/services/report_dropdwon_options_service.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';

const applyCycleOptions = [
  'daily',
  'weekly',
  'monthly',
  'quarterly',
  'yearly',
  'custom',
];

const _fieldTypeAliases = <String, String>{
  'text': 'text',
  'number': 'number',
  'integer': 'number',
  'int': 'number',
  'decimal': 'decimal',
  'float': 'decimal',
  'double': 'decimal',
  'date': 'date',
  'datetime': 'date',
  'checkbox': 'checkbox',
  'bool': 'checkbox',
  'boolean': 'checkbox',
  'checkbox_list': 'checkbox_list',
  'checklist': 'checkbox_list',
  'multi_checkbox': 'checkbox_list',
  'dropdown': 'dropdown',
  'select': 'dropdown',
  'enum': 'dropdown',
  'textarea': 'textarea',
  'text_area': 'textarea',
  'multiline': 'textarea',
  'file': 'file',
  'upload': 'file',
  'attachment': 'file',
  'label': 'label',
  'section': 'section',
};

const _serverKeys = {
  'created_at',
  'updated_at',
  'createdAt',
  'updatedAt',
  'reportFieldID',
  'reportTypeID',
};

List<String> splitCsv(String? raw) =>
    (raw ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

String joinCsv(Iterable<dynamic> items) =>
    items.map((e) => e.toString().trim()).where((s) => s.isNotEmpty).join(',');

String safeOption(dynamic raw, List<String> options) {
  final value = raw?.toString() ?? '';
  return options.contains(value) ? value : options.first;
}

String _normaliseFieldType(dynamic raw) =>
    _fieldTypeAliases[raw?.toString().toLowerCase().trim()] ?? 'text';

String? _str(dynamic value) => value?.toString();

List<dynamic>? _asList(dynamic value) =>
    (value is List && value.isNotEmpty) ? value : null;

List<String> _categoryIdsOf(dynamic raw) {
  final parts = raw is List ? raw : [raw];
  return parts
      .expand((e) => (e?.toString() ?? '').split(','))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toSet()
      .toList();
}

List<Map<String, dynamic>> _castJsonList(dynamic raw) =>
    raw is List
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : [];

String? _resolveId(dynamic data) {
  if (data == null) return null;

  for (final read in <dynamic Function()>[
        () => data.reportTypeID,
        () => data.reportTypeId,
        () => data.categoryId,
  ]) {
    try {
      final value = read()?.toString();
      if (value != null && value.isNotEmpty) return value;
    } catch (_) {}
  }

  if (data is Map) {
    for (final key in [
      'reportTypeID',
      'reportTypeId',
      'categoryId',
      'categoryID',
      'id',
    ]) {
      final value = data[key]?.toString();
      if (value != null && value.isNotEmpty) return value;
    }
  }
  return null;
}

enum ReportFlag {
  isExternalReport('External Report', false),
  defaultAsDraft('Default as Draft', true),
  archived('Archived', false),
  updateItemStatus('Update Item Status', true),
  updateItemDates('Update Item Dates', true),
  isStatusRequired('Status Required', true);

  const ReportFlag(this.label, this.initial);

  final String label;
  final bool initial;
}

enum ReportMulti { possibleStatus, possibleBatchStatus, permission }

class ReportDraft {
  final String name;
  final String savedAt;
  final Map<String, dynamic> data;

  const ReportDraft({
    required this.name,
    required this.savedAt,
    required this.data,
  });
}

class ReportFormProvider extends ChangeNotifier {
  ReportFormProvider(this._system);

  static const steps = ['Overview', 'Fields', 'Dates'];

  final SystemProvider _system;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final documentCodeController = TextEditingController();

  final _flags = {for (final f in ReportFlag.values) f: f.initial};
  final _multi = {for (final m in ReportMulti.values) m: <String>[]};

  bool _disposed = false;
  int _step = 0;
  bool _isEditMode = false;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _loadError;
  String _batchReportType = '';
  List<String> _categoryIds = [];
  List<Map<String, dynamic>> _fields = [];
  List<Map<String, dynamic>> _dates = [];
  dynamic _editData;
  dynamic _fullItem;

  int get step => _step;
  bool get isEditMode => _isEditMode;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get isLastStep => _step == steps.length - 1;
  String? get loadError => _loadError;
  String get batchReportType => _batchReportType;
  List<String> get categoryIds => _categoryIds;
  List<Map<String, dynamic>> get fields => _fields;
  List<Map<String, dynamic>> get dates => _dates;

  List<String> get availableSections =>
      _fields
          .where((f) => f['fieldType'] == 'section')
          .map((f) => f['labelText']?.toString().trim() ?? '')
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();

  List<String> get availableFieldNames =>
      _fields
          .map((f) => f['name']?.toString() ?? '')
          .where((n) => n.isNotEmpty)
          .toList();

  String? get _optionsReportTypeId =>
      _isEditMode ? _resolveId(_editData) : _categoryIds.firstOrNull;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    nameController.dispose();
    descriptionController.dispose();
    documentCodeController.dispose();
    super.dispose();
  }

  bool flag(ReportFlag flag) => _flags[flag]!;

  void setFlag(ReportFlag flag, bool value) {
    _flags[flag] = value;
    notifyListeners();
  }

  List<String> multi(ReportMulti multi) => _multi[multi]!;

  void setMulti(ReportMulti multi, List<String> values) {
    _multi[multi] = values;
    notifyListeners();
  }

  void setBatchReportType(String? value) {
    _batchReportType = value ?? 'No Batch';
    notifyListeners();
  }

  void setCategoryIds(List<String> ids) {
    _categoryIds = List.of(ids);
    notifyListeners();
  }

  void removeCategory(String id) {
    _categoryIds.remove(id);
    notifyListeners();
  }

  void next() {
    if (_step == 1) _saveDropdownOptions();
    _step++;
    notifyListeners();
  }

  void back() {
    if (_step == 0) return;
    _step--;
    notifyListeners();
  }

  Map<String, dynamic> fieldAt(int? index) =>
      index != null
          ? Map.of(_fields[index])
          : {
        'labelText': '',
        'name': '',
        'fieldType': 'text',
        'defaultValue': '',
        'section': '',
        'onlyAvailable': '',
        'onlyAvailableField': '',
        'onlyAvailableOperator': '==',
        'onlyAvailableValue': '',
        'isRequired': false,
        'isReadOnly': false,
        'permissionField': '',
        'doNotCopy': false,
        'infoText': '',
        'isArchive': false,
        'appendPDF': false,
        'fileExtensions': '',
        'options': '',
      };

  Map<String, dynamic> dateAt(int? index) =>
      index != null
          ? Map.of(_dates[index])
          : {
        'name': '',
        'applyCycle': 'daily',
        'isRequired': true,
        'disableFreeType': false,
      };

  void saveField(int? index, Map<String, dynamic> field) {
    if (index == null) {
      _fields.add(field);
    } else {
      _fields[index] = field;
    }
    notifyListeners();
  }

  void saveDate(int? index, Map<String, dynamic> date) {
    if (index == null) {
      _dates.add(date);
    } else {
      _dates[index] = date;
    }
    notifyListeners();
  }

  void removeField(int index) {
    _fields.removeAt(index);
    notifyListeners();
  }

  void removeDate(int index) {
    _dates.removeAt(index);
    notifyListeners();
  }

  Future<ReportDraft?> init(Map<String, dynamic>? args) async {
    _isEditMode = args?['isEdit'] ?? false;
    _editData = args?['reportData'];
    _fullItem = args?['fullReportItem'];

    if (_isEditMode && _editData != null) {
      await _loadForEdit(args);
      return null;
    }
    return _readDraft();
  }

  Future<void> _loadForEdit(Map<String, dynamic>? args) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id =
          _resolveId(_editData) ??
              _resolveId(_fullItem?.reportType) ??
              args?['reportTypeID']?.toString() ??
              args?['reportTypeId']?.toString();

      if (id == null) {
        _applyShallow();
      } else {
        await _fetchAndApply(id);
      }
    } catch (e) {
      _loadError = 'Failed to load report details: $e';
      _applyShallow();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAndApply(String id) async {
    final datum = await _system.fetchReportTypeById(id);
    if (_disposed) return;
    if (datum == null) return _applyShallow();

    final rt = datum.reportType;
    final List<dynamic>? rawFields =
    _system.currentReportTypeRawFields.isNotEmpty
        ? _system.currentReportTypeRawFields
        : _asList(datum.reportFields);
    final rawDates = _asList(datum.reportTypeDates);

    nameController.text =
        _str(rt?.reportName) ?? _str(_editData?.reportName) ?? '';
    descriptionController.text =
        _str(rt?.description) ?? _str(_editData?.description) ?? '';
    documentCodeController.text =
        _str(rt?.documentCode) ?? _str(_editData?.documentCode) ?? '';

    _batchReportType = _str(rt?.batchReportType) ?? '';
    _multi[ReportMulti.possibleStatus] = splitCsv(_str(rt?.possibleStatus));
    _multi[ReportMulti.possibleBatchStatus] = splitCsv(
      _str(rt?.possibleBatchStatus),
    );
    _multi[ReportMulti.permission] = splitCsv(_str(rt?.permission));
    _categoryIds = _categoryIdsOf(rt?.categoryId);

    _flags
      ..[ReportFlag.isExternalReport] = rt?.isExternalReport ?? false
      ..[ReportFlag.defaultAsDraft] = rt?.defaultAsDraft ?? true
      ..[ReportFlag.archived] = rt?.archived ?? _editData?.archived ?? false
      ..[ReportFlag.updateItemStatus] = rt?.updateItemStatus ?? true
      ..[ReportFlag.updateItemDates] = rt?.updateItemDates ?? true
      ..[ReportFlag.isStatusRequired] = rt?.isStatusRequired ?? true;

    if (rawFields != null) _fields = rawFields.map(_parseField).toList();
    if (rawDates != null) _dates = rawDates.map(_parseDate).toList();
  }

  void _applyShallow() {
    if (_disposed) return;
    nameController.text = _str(_editData?.reportName) ?? '';
    descriptionController.text = _str(_editData?.description) ?? '';
    documentCodeController.text = _str(_editData?.documentCode) ?? '';
    _flags[ReportFlag.archived] = _editData?.archived ?? false;
  }

  Map<String, dynamic> _parseField(dynamic raw) {
    final f = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    f['fieldType'] = _normaliseFieldType(f['fieldType']);

    final dv = f['defaultValue'];

    if (f['fieldType'] != 'dropdown') {
      f['defaultValue'] = (dv is List || dv is Map) ? '' : (dv?.toString() ?? '');
      return f;
    }

    f['dropdownType'] ??= 'typed';
    final hasOptions = (f['options']?.toString() ?? '').isNotEmpty;

    if (dv is Map) {
      final embedded = dv['options'];
      if (embedded is List && embedded.isNotEmpty && !hasOptions) {
        f['options'] = joinCsv(embedded);
      }
      final value = dv['value'];
      f['defaultValue'] =
      (value == null || value is Map || value is List)
          ? ''
          : value.toString();
    } else {
      final text = dv?.toString() ?? '';
      f['defaultValue'] = text;
      if (text.contains(',') && !hasOptions) {
        f['options'] = text;
        f['defaultValue'] = '';
      }
    }
    return f;
  }

  Map<String, dynamic> _parseDate(dynamic raw) {
    final d = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    d['applyCycle'] = safeOption(d['applyCycle'], applyCycleOptions);
    return d;
  }

  Map<String, dynamic> _cleanField(Map<String, dynamic> field) {
    final f = Map<String, dynamic>.from(field)
      ..removeWhere((key, _) => _serverKeys.contains(key));

    String text(String key, [String fallback = '']) =>
        f[key]?.toString() ?? fallback;

    f
      ..['labelText'] = text('labelText')
      ..['name'] = text('name')
      ..['fieldType'] = _normaliseFieldType(f['fieldType'])
      ..['section'] = text('section')
      ..['onlyAvailable'] = text('onlyAvailable', 'all')
      ..['permissionField'] = text('permissionField')
      ..['infoText'] = text('infoText')
      ..['isRequired'] = f['isRequired'] == true
      ..['doNotCopy'] = f['doNotCopy'] == true
      ..['isArchive'] = f['isArchive'] == true;

    final dv = f['defaultValue'];

    if (f['fieldType'] == 'dropdown') {
      f['dropdownType'] ??= 'typed';
      final rawOptions = text('options');
      final options = splitCsv(rawOptions);

      if (options.isNotEmpty) {
        f['defaultValue'] = {
          'dropdownType':
          dv is Map ? dv['dropdownType']?.toString() ?? 'Options' : 'Options',
          'options': options,
          'value':
          dv is Map
              ? dv['value']
              : (dv?.toString().isNotEmpty == true ? dv.toString() : null),
        };
      } else if (dv is! Map) {
        f['defaultValue'] = '';
      }
      f['options'] = rawOptions;
    } else if (dv is! Map) {
      f['defaultValue'] = dv is List ? '' : dv?.toString() ?? '';
    }

    return f;
  }

  Map<String, List<String>> _optionsMap() {
    final result = <String, List<String>>{};
    for (final field in _fields) {
      if (field['fieldType']?.toString() != 'dropdown') continue;

      final name = field['name']?.toString().trim() ?? '';
      final options = splitCsv(field['options']?.toString());
      if (name.isNotEmpty && options.isNotEmpty) result[name] = options;
    }
    return result;
  }

  Future<void> _saveDropdownOptions() => ReportDropdownOptionsService.save(
    reportName: nameController.text.trim(),
    optionsMap: _optionsMap(),
    reportTypeId: _optionsReportTypeId,
  );

  Map<String, dynamic> _draftJson() => {
    'reportName': nameController.text,
    'description': descriptionController.text,
    'documentCode': documentCodeController.text,
    'batchReportType': _batchReportType,
    'selectedCategoryIds': _categoryIds,
    'reportFields': _fields,
    'reportTypeDates': _dates,
    for (final f in ReportFlag.values) f.name: _flags[f],
    for (final m in ReportMulti.values) m.name: joinCsv(_multi[m]!),
  };

  ReportDraft? _readDraft() {
    final data = LocalStorage.getJson(LocalStorageConstant.reportDraft);
    final name = data?['reportName']?.toString() ?? '';
    if (data == null || name.isEmpty) return null;

    return ReportDraft(
      name: name,
      savedAt: LocalStorage.getString(
        LocalStorageConstant.lastReportDraftTimestamp,
      ),
      data: data,
    );
  }

  Future<void> saveDraft() async {
    await LocalStorage.setJson(LocalStorageConstant.reportDraft, _draftJson());
    await LocalStorage.setString(
      LocalStorageConstant.lastReportDraftTimestamp,
      DateTime.now().toIso8601String(),
    );
    await _saveDropdownOptions();
  }

  void applyDraft(Map<String, dynamic> draft) {
    nameController.text = draft['reportName'] ?? '';
    descriptionController.text = draft['description'] ?? '';
    documentCodeController.text = draft['documentCode'] ?? '';
    _batchReportType = draft['batchReportType'] ?? '';
    _categoryIds = List<String>.from(draft['selectedCategoryIds'] ?? []);
    _fields = _castJsonList(draft['reportFields']);
    _dates = _castJsonList(draft['reportTypeDates']);

    for (final f in ReportFlag.values) {
      _flags[f] = draft[f.name] ?? f.initial;
    }
    for (final m in ReportMulti.values) {
      _multi[m] = splitCsv(draft[m.name]?.toString());
    }
    notifyListeners();
  }

  Future<void> clearDraft() async {
    await LocalStorage.remove(LocalStorageConstant.reportDraft);
    await LocalStorage.remove(LocalStorageConstant.lastReportDraftTimestamp);
  }

  Map<String, dynamic> _reportTypeJson() => {
    'reportName': nameController.text.trim(),
    'description': descriptionController.text.trim(),
    'documentCode': documentCodeController.text.trim(),
    'batchReportType': _batchReportType.trim(),
    'categoryID': _categoryIds.isEmpty ? null : _categoryIds,
    for (final f in ReportFlag.values) f.name: _flags[f],
    for (final m in ReportMulti.values) m.name: joinCsv(_multi[m]!),
  };

  Future<String?> submit() async {
    if (nameController.text.trim().isEmpty) {
      _step = 0;
      notifyListeners();
      return 'Please enter a report name';
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final reportType = _reportTypeJson();
      final reportFields = _fields.map(_cleanField).toList();

      if (_isEditMode) {
        await _system.updateReport(
          reportId: _resolveId(_editData) ?? '',
          reportType: reportType,
          competencyReports: [],
          reportTypeDates: _dates,
          statusRuleReports: [],
          reportFields: reportFields,
          actionReports: [],
        );
      } else {
        await _system.createReport(
          reportType: reportType,
          competencyReports: [],
          reportTypeDates: _dates,
          statusRuleReports: [],
          reportFields: reportFields,
          actionReports: [],
        );
      }

      if (_system.hasError) return 'Error: ${_system.errorMessage}';

      await _saveDropdownOptions();
      await clearDraft();
      return null;
    } catch (e) {
      return 'Error: $e';
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}