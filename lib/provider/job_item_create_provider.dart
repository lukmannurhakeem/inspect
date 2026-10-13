import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/screen/job/job_item_create/job_item_form_models.dart';
import 'package:inspect/screen/job/job_item_create/job_item_mapper.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/file_upload_controller.dart';

class JobItemCreateProvider extends ChangeNotifier {
  JobItemCreateProvider({
    required this.jobId,
    required CategoryProvider categoryProvider,
    required JobProvider jobProvider,
    required SiteProvider siteProvider,
    CategoryItem? selectedCategory,
    List<Map<String, dynamic>> preloadedFields = const [],
    this.isEditMode = false,
    this.existingItem,
  }) : _categoryProvider = categoryProvider,
       _jobProvider = jobProvider,
       _siteProvider = siteProvider,
       _preloadedFields = selectedCategory == null ? const [] : preloadedFields {
    _resolveInitialCategory(selectedCategory);
  }

  static const _autoItemNo = '__AUTO__';
  static const _pendingStatus = 'pending_submission';
  static const _sectionOrder = [
    'Basic Information',
    'Location Details',
    'Manufacturer Information',
    'Other',
  ];
  static const _basicTypes = {
    'ItemDescription',
    'Customer',
    'SiteID',
    'ItemCategory',
    'ApplicableCode',
  };

  final String jobId;
  final bool isEditMode;
  final Map<String, dynamic>? existingItem;

  final CategoryProvider _categoryProvider;
  final JobProvider _jobProvider;
  final SiteProvider _siteProvider;
  final List<Map<String, dynamic>> _preloadedFields;

  final categoryController = TextEditingController();
  final singleItemNoController = TextEditingController();
  final batchTemplateController = TextEditingController();
  final batchFromController = TextEditingController();
  final batchToController = TextEditingController();
  final batchCountController = TextEditingController();
  final manualItemNoController = TextEditingController();
  final fieldControllers = <String, TextEditingController>{};
  final fileControllers = <String, FileUploadController>{};

  CategoryItem? _selectedCategory;
  ItemNoCreationMode _itemNoMode = ItemNoCreationMode.singleItem;
  bool _generateItemNo = false;
  bool _batchGenerateItemNo = false;
  bool _manualGenerateItemNo = false;
  bool _isLoading = false;
  bool _isLoadingFields = false;
  bool _disposed = false;
  List<JobFormField> _fields = const [];
  Map<String, List<JobFormField>> _sections = const {};

  CategoryItem? get selectedCategory => _selectedCategory;
  ItemNoCreationMode get itemNoMode => _itemNoMode;
  bool get generateItemNo => _generateItemNo;
  bool get batchGenerateItemNo => _batchGenerateItemNo;
  bool get manualGenerateItemNo => _manualGenerateItemNo;
  bool get isLoading => _isLoading;
  bool get isLoadingFields => _isLoadingFields;
  List<JobFormField> get fields => _fields;
  Map<String, List<JobFormField>> get sections => _sections;

  String get saveLabel {
    if (_isLoading) return isEditMode ? 'Updating...' : 'Saving...';
    return switch (_itemNoMode) {
      ItemNoCreationMode.singleItem =>
        isEditMode ? 'Update Item' : 'Save Item',
      ItemNoCreationMode.batchCreation => 'Create Batch',
      ItemNoCreationMode.batchCreationManual => 'Save Item',
    };
  }

  String get _effectiveJobId =>
      jobId.isNotEmpty
          ? jobId
          : JobItemMapper.firstValue(existingItem ?? const {}, [
            'jobID',
            'jobId',
            'job_id',
          ]);

  Future<void> initialize(BuildContext context) async {
    final initialLoad = _loadInitialFields();
    _categoryProvider.fetchCategories();
    _jobProvider.fetchCustomers(context);
    _siteProvider.fetchSite(context);
    _jobProvider.fetchJobLocations();
    await initialLoad;
  }

  Future<void> selectCategory(CategoryItem category) {
    _selectedCategory = category;
    categoryController.text = category.name;
    return loadFields(category.id);
  }

  Future<void> loadFields(String categoryId) async {
    _isLoadingFields = true;
    notifyListeners();

    try {
      final found = await _categoryProvider.loadFieldsFromLocalStorage(
        categoryId,
      );
      if (!found || _categoryProvider.getFieldsAsJson().isEmpty) {
        try {
          await _categoryProvider.fetchCategories();
          await _categoryProvider.loadFieldsFromLocalStorage(categoryId);
        } catch (e) {
          debugPrint('API fetch failed during field load: $e');
        }
      }
      if (!_disposed) _applyFields(_categoryProvider.getFieldsAsJson());
    } catch (e) {
      debugPrint('Error loading fields: $e');
    } finally {
      _isLoadingFields = false;
      notifyListeners();
    }
  }

  void setItemNoMode(ItemNoCreationMode mode) {
    _itemNoMode = mode;
    notifyListeners();
  }

  void setGenerateItemNo(bool value) {
    _generateItemNo = value;
    if (value) singleItemNoController.clear();
    notifyListeners();
  }

  void setBatchGenerateItemNo(bool value) {
    _batchGenerateItemNo = value;
    if (!value) batchCountController.clear();
    notifyListeners();
  }

  void setManualGenerateItemNo(bool value) {
    _manualGenerateItemNo = value;
    if (value) manualItemNoController.clear();
    notifyListeners();
  }

  void setFieldText(TextEditingController controller, String value) {
    controller.text = value;
    notifyListeners();
  }

  void toggleChecklistOption(TextEditingController controller, String option) {
    final values = JobItemMapper.checkedOptions(controller.text);
    if (!values.remove(option)) values.add(option);
    setFieldText(controller, values.join(','));
  }

  Future<SaveResult> save(BuildContext context) async {
    final List<String> itemNumbers;
    try {
      _validate();
      itemNumbers = _resolveItemNumbers();
    } on FormValidationException catch (e) {
      return SaveResult(SaveStatus.invalid, e.message);
    }

    _isLoading = true;
    notifyListeners();

    try {
      final effectiveJobId = _effectiveJobId;
      final items = _buildItems(itemNumbers, effectiveJobId);
      return await _isOnline()
          ? await _submit(context, items, effectiveJobId)
          : await _saveOffline(items);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    categoryController.dispose();
    singleItemNoController.dispose();
    batchTemplateController.dispose();
    batchFromController.dispose();
    batchToController.dispose();
    batchCountController.dispose();
    manualItemNoController.dispose();
    _disposeFieldControllers();
    super.dispose();
  }

  void _resolveInitialCategory(CategoryItem? provided) {
    var category = provided;
    final data = existingItem;

    if (category == null && isEditMode && data != null) {
      final id = JobItemMapper.firstValue(data, [
        'categoryID',
        'categoryId',
        'category_id',
      ]);
      if (id.isNotEmpty) {
        final name = JobItemMapper.firstValue(data, [
          'categoryName',
          'category_name',
        ]);
        category = CategoryItem(
          id: id,
          name: name.isNotEmpty ? name : id,
          children: [],
          level: 0,
        );
      }
    }

    _selectedCategory = category;
    categoryController.text = category?.name ?? '';
  }

  Future<void> _loadInitialFields() async {
    final category = _selectedCategory;
    if (category == null) return;

    if (_preloadedFields.isNotEmpty) {
      _applyFields(_preloadedFields);
      notifyListeners();
    } else {
      await loadFields(category.id);
    }
  }

  void _applyFields(List<Map<String, dynamic>> raw) {
    _disposeFieldControllers();
    _fields = raw.map(JobFormField.fromMap).toList();
    _sections = _groupBySection(_fields);

    for (final field in _fields) {
      if (field.isItemNo) continue;
      if (field.isFile) {
        fileControllers[field.id] = FileUploadController();
      } else {
        fieldControllers[field.id] = TextEditingController(
          text: field.defaultValue,
        );
      }
    }

    _prefillIfEditing();
  }

  void _prefillIfEditing() {
    final data = existingItem;
    if (!isEditMode || data == null) return;

    final itemNo = JobItemMapper.firstValue(data, [
      'itemNo',
      'item_no',
      'ItemNo',
    ]);
    if (itemNo.isNotEmpty) singleItemNoController.text = itemNo;

    for (final field in _fields) {
      final controller = fieldControllers[field.id];
      if (controller == null) continue;
      final value = JobItemMapper.prefillValue(data, field);
      if (value.isNotEmpty) controller.text = value;
    }
  }

  void _disposeFieldControllers() {
    for (final c in fieldControllers.values) {
      c.dispose();
    }
    fieldControllers.clear();
    for (final c in fileControllers.values) {
      c.dispose();
    }
    fileControllers.clear();
  }

  static Map<String, List<JobFormField>> _groupBySection(
    Iterable<JobFormField> fields,
  ) {
    final grouped = <String, List<JobFormField>>{
      for (final section in _sectionOrder) section: [],
    };
    for (final field in fields.where((f) => !f.isItemNo)) {
      grouped[_sectionOf(field)]!.add(field);
    }
    grouped.removeWhere((_, value) => value.isEmpty);
    return grouped;
  }

  static String _sectionOf(JobFormField field) {
    final label = field.lowerLabel;
    if (_basicTypes.contains(field.type) ||
        label.contains('description') ||
        label.contains('applicable code')) {
      return 'Basic Information';
    }
    if (JobFormField.locationTypes.contains(field.type) ||
        label.contains('location')) {
      return 'Location Details';
    }
    if (label.contains('manufacture')) return 'Manufacturer Information';
    return 'Other';
  }

  void _validate() {
    if (_selectedCategory == null) {
      throw const FormValidationException('Please select a category');
    }

    for (final field in _fields.where((f) => f.isRequired && !f.isItemNo)) {
      final filled =
          field.isFile
              ? fileControllers[field.id]?.hasFile ?? false
              : fieldControllers[field.id]?.text.trim().isNotEmpty ?? false;
      if (!filled) {
        throw FormValidationException('${field.label} is required');
      }
    }
  }

  List<String> _resolveItemNumbers() {
    switch (_itemNoMode) {
      case ItemNoCreationMode.singleItem:
        return _singleItemNumber(_generateItemNo, singleItemNoController);
      case ItemNoCreationMode.batchCreationManual:
        return _singleItemNumber(_manualGenerateItemNo, manualItemNoController);
      case ItemNoCreationMode.batchCreation:
        return _batchItemNumbers();
    }
  }

  List<String> _singleItemNumber(bool generate, TextEditingController c) {
    if (generate) return [_autoItemNo];
    final itemNo = c.text.trim();
    if (itemNo.isEmpty) {
      throw const FormValidationException('Please enter an Item No');
    }
    return [itemNo];
  }

  List<String> _batchItemNumbers() {
    if (_batchGenerateItemNo) {
      final count = int.tryParse(batchCountController.text.trim());
      if (count == null || count <= 0) {
        throw const FormValidationException(
          'Please enter a valid "Number to Generate"',
        );
      }
      return List.filled(count, _autoItemNo);
    }

    final from = int.tryParse(batchFromController.text.trim());
    final to = int.tryParse(batchToController.text.trim());
    if (from == null || to == null) {
      throw const FormValidationException(
        'Please enter valid numeric values for "Create From" and "To"',
      );
    }
    if (to < from) {
      throw const FormValidationException('"To" must be >= "From"');
    }

    final template = batchTemplateController.text.trim();
    return List.generate(to - from + 1, (i) => '$template${from + i}');
  }

  List<Map<String, dynamic>> _buildItems(
    List<String> itemNumbers,
    String effectiveJobId,
  ) {
    final existing = isEditMode ? existingItem : null;
    final base = <String, dynamic>{
      if (effectiveJobId.isNotEmpty) 'jobID': effectiveJobId,
      'categoryName': _selectedCategory!.name,
      'categoryID': _selectedCategory!.id,
      'status': existing?['status'] ?? _pendingStatus,
    };
    final itemData = <String, dynamic>{};

    for (final field in _fields.where((f) => !f.isItemNo)) {
      if (field.isFile) {
        final controller = fileControllers[field.id];
        if (controller != null && controller.hasFile) {
          itemData[field.name] = controller.fileName;
        }
        continue;
      }

      final controller = fieldControllers[field.id];
      if (controller == null) continue;
      final value = controller.text.trim();

      if (JobItemMapper.isStaticField(field)) {
        JobItemMapper.writeStaticField(base, field, value);
      } else if (value.isNotEmpty) {
        itemData[field.name] =
            field.type == 'Date' ? JobItemMapper.toIsoDateTime(value) : value;
      }
    }

    if (itemData.isNotEmpty) base['itemData'] = itemData;

    final itemId =
        existing == null
            ? null
            : JobItemMapper.firstValue(existing, [
              'itemId',
              'item_id',
              'itemID',
            ]);
    final anyGenerate =
        _generateItemNo || _batchGenerateItemNo || _manualGenerateItemNo;

    return itemNumbers
        .map(
          (itemNo) => {
            ...base,
            if (itemId != null) 'itemId': itemId,
            'itemNo': itemNo == _autoItemNo ? '' : itemNo,
            'generateItemNo': itemNo == _autoItemNo || anyGenerate,
          },
        )
        .toList();
  }

  Future<SaveResult> _submit(
    BuildContext context,
    List<Map<String, dynamic>> items,
    String effectiveJobId,
  ) async {
    try {
      if (items.length > 1) {
        await Future.wait(
          items.map(
            (item) => _jobProvider.createJobItemNoNav(
              context,
              item,
              effectiveJobId,
            ),
          ),
        );
        await _cacheCompleted(items);
        await _refreshRegister(context, effectiveJobId);
        return SaveResult(
          SaveStatus.success,
          '${items.length} items created successfully.',
        );
      }

      final item = items.single;
      if (isEditMode && existingItem != null) {
        await _jobProvider.updateJobItem(
          context,
          item['itemId'] as String,
          item,
        );
        await _refreshRegister(context, effectiveJobId);
      } else {
        await _jobProvider.createJobItemNoNav(context, item, effectiveJobId);
        await _cacheCompleted(items);
      }
      return const SaveResult(SaveStatus.success);
    } catch (_) {
      await _saveDrafts(items);
      return const SaveResult(
        SaveStatus.offlineFallback,
        'Saved locally. Will sync when online.',
      );
    }
  }

  Future<SaveResult> _saveOffline(List<Map<String, dynamic>> items) async {
    try {
      await _saveDrafts(items);
      final message =
          items.length > 1
              ? '${items.length} items saved locally. Sync when online.'
              : isEditMode
              ? 'Item updated locally. Sync when online.'
              : 'Saved locally. Will sync when online.';
      return SaveResult(SaveStatus.offline, message);
    } catch (e) {
      return SaveResult(SaveStatus.failure, 'Error saving offline: $e');
    }
  }

  Future<void> _refreshRegister(
    BuildContext context,
    String effectiveJobId,
  ) async {
    if (effectiveJobId.isEmpty) return;
    try {
      await _jobProvider.fetchJobRegisterModel(context, effectiveJobId);
    } catch (e) {
      debugPrint('fetchJobRegisterModel failed: $e');
    }
  }

  Future<void> _saveDrafts(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await JobItemStorage.saveDraft(jobId, {
        ...item,
        'status': _pendingStatus,
        'isPending': true,
      });
    }
  }

  Future<void> _cacheCompleted(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      try {
        await JobItemStorage.saveCompletedItem(jobId, {
          ...item,
          'status': 'submitted',
          'isPending': false,
          'submittedAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('Error saving completed item locally: $e');
      }
    }
  }

  Future<bool> _isOnline() async {
    try {
      return await Connectivity().checkConnectivity() !=
          ConnectivityResult.none;
    } catch (_) {
      return false;
    }
  }
}
