import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/create_category_model/create_category_model.dart';
import 'package:inspect/data/model/field_model/field_model.dart';
import 'package:inspect/data/model/get_category_model/get_category_model.dart';
import 'package:inspect/data/repository/category/category_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/storage/local_category_storage_service.dart';
import 'package:inspect/storage/local_storage.dart';


class CategoryItem {
  String id;
  String name;
  String? parentId;
  String? parentName;
  List<CategoryItem> children;
  bool isExpanded;
  bool canHaveChildItems;
  bool isWithdrawn;
  String? categoryCode;
  String? description;
  int level;

  CategoryItem({
    required this.id,
    required this.name,
    this.parentId,
    this.parentName,
    List<CategoryItem>? children,
    this.isExpanded = false,
    this.canHaveChildItems = false,
    this.isWithdrawn = false,
    this.categoryCode,
    this.description,
    this.level = 0,
  }) : children = children != null ? List.from(children) : <CategoryItem>[];

  bool get hasDescendants {
    if (children.isNotEmpty) return true;
    return children.any((child) => child.hasDescendants);
  }
}

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = ServiceLocator().categoryRepository;

  static const _kCategoryListKey = 'cached_category_list';
  static const _pageLimit = 50;

  static const List<String> _defaultFieldTypes = [
    'ItemNo',
    'ItemIsArchived',
    'ItemDescription',
    'RFIDNo',
    'Customer',
    'SiteID',
    'ItemLocation',
  ];

  static List<FieldModel> get _defaultFields => [
    FieldModel(
      id: '1',
      labelText: 'Item No',
      name: 'ItemNo',
      fieldType: 'ItemNo',
    ),
    FieldModel(
      id: '2',
      labelText: 'Archived',
      name: 'ItemIsArchived',
      fieldType: 'ItemIsArchived',
      isArchived: true,
    ),
    FieldModel(
      id: '3',
      labelText: 'RFID No',
      name: 'RFIDNo',
      fieldType: 'RFIDNo',
    ),
    FieldModel(
      id: '4',
      labelText: 'Location',
      name: 'ItemLocation',
      fieldType: 'ItemLocation',
    ),
    FieldModel(
      id: '5',
      labelText: 'Detailed Location',
      name: 'DetailedLocation',
      fieldType: 'Text',
    ),
  ];

  static const List<String> _availableFieldTypes = [
    'Text',
    'Multi-Line Textbox',
    'Numeric',
    'Decimal',
    'Date',
    'Dropdown',
    'Override Dropdown',
    'Conditional Dropdown',
    'Site Dropdown',
    'Boolean',
    'Checklist Item',
    'Colour Picker',
    'File',
    'Signature',
    'Label',
    'Section',
    'ItemNo',
    'ItemDescription',
    'ItemCategory',
    'ItemLocation',
    'RFIDNo',
    'LatestPhoto',
    'Location',
    'ApplicableCode',
  ];

  // ── Field state ───────────────────────────────────────────────────────────

  List<FieldModel> _fields = List.from(_defaultFields);
  List<Map<String, dynamic>> _apiFields = [];
  bool _fieldsLoadedFromApi = false;
  bool _showArchived = false;
  bool _canHaveChild = false;
  bool _isWithdrawn = false;
  String? _createdCategoryId;

  Map<String, String> _fieldCreationErrors = {};
  bool _isCreatingFields = false;

  List<FieldModel> get fields => _showArchived
      ? _fields
      : _fields.where((f) => !f.isArchived).toList();
  bool get showArchived => _showArchived;
  bool get showCanHaveChild => _canHaveChild;
  bool get showIsWithdrawn => _isWithdrawn;
  String? get createdCategoryId => _createdCategoryId;
  Map<String, String> get fieldCreationErrors => _fieldCreationErrors;
  bool get isCreatingFields => _isCreatingFields;
  List<String> get availableFieldTypes => _availableFieldTypes;

  void toggleShowArchived() {
    _showArchived = !_showArchived;
    notifyListeners();
  }

  void toggleCanHaveChild() {
    _canHaveChild = !_canHaveChild;
    notifyListeners();
  }

  void toggleIsWithdrawn() {
    _isWithdrawn = !_isWithdrawn;
    notifyListeners();
  }

  void addField(FieldModel field) {
    _fields.add(
      field.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
    );
    notifyListeners();
  }

  void removeField(String id) {
    _fields.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  void updateField(String id, FieldModel updatedField) {
    final index = _fields.indexWhere((f) => f.id == id);
    if (index == -1) return;
    _fields[index] = updatedField.copyWith(id: id);
    notifyListeners();
  }

  // ── Field (de)serialisation ───────────────────────────────────────────────

  Map<String, dynamic> _fieldToJson(FieldModel field) => {
    'id': field.id,
    'labelText': field.labelText,
    'name': field.name,
    'fieldType': field.fieldType,
    'defaultValue': field.defaultValue,
    'required': field.required,
    'isArchived': field.isArchived,
    'permissions': field.permissions,
    'dropdownOptions': field.dropdownOptions,
  };

  FieldModel _fieldFromJson(Map<String, dynamic> json) => FieldModel(
    id: json['id'] ?? '',
    labelText: json['labelText'] ?? '',
    name: json['name'] ?? '',
    fieldType: json['fieldType'] ?? 'Text',
    defaultValue: json['defaultValue'],
    required: json['required'] ?? false,
    isArchived: json['isArchived'] ?? false,
    permissions: json['permissions'] != null
        ? Map<String, String>.from(json['permissions'])
        : {},
    dropdownOptions: json['dropdownOptions'] != null
        ? List<String>.from(json['dropdownOptions'])
        : null,
  );

  List<Map<String, dynamic>> getFieldsAsJson() {
    if (_fieldsLoadedFromApi && _apiFields.isNotEmpty) {
      return _apiFields
          .map(_mapApiFieldToInternal)
          .where((f) => f['isArchived'] != true)
          .toList();
    }
    return _fields.where((f) => !f.isArchived).map(_fieldToJson).toList();
  }

  Map<String, dynamic> _mapApiFieldToInternal(Map<String, dynamic> api) {
    List<String>? dropdownOptions;
    String defaultValue = '';

    final fv = api['fieldVariable'];
    if (fv is Map) {
      final opts = fv['options'];
      if (opts is List && opts.isNotEmpty) {
        dropdownOptions = opts.map((e) => e.toString()).toList();
      }

      if (dropdownOptions == null) {
        final v = fv['value'];
        if (v is List && v.isNotEmpty) {
          dropdownOptions = v.map((e) => e.toString()).toList();
        } else if (v != null && v.toString().isNotEmpty) {
          defaultValue = v.toString();
        }
      }
    }

    final gp = api['groupPermissions']?.toString() ?? 'Any';

    return {
      'id': api['fieldId']?.toString() ?? '',
      'fieldId': api['fieldId']?.toString() ?? '',
      'categoryId': api['categoryId']?.toString() ?? '',
      'name': api['fieldName']?.toString() ?? '',
      'labelText': api['labelText']?.toString() ?? '',
      'fieldType': api['fieldType']?.toString() ?? 'Text',
      'defaultValue': defaultValue,
      'dropdownOptions': dropdownOptions,
      'required': api['isRequired'] as bool? ?? false,
      'isArchived': api['isArchive'] as bool? ?? false,
      'doNotCopy': api['doNotCopy'] as bool? ?? false,
      'infoText': api['infoText']?.toString(),
      'permissions': <String, String>{'create': gp, 'view': gp},
      'createdAt': api['createdAt']?.toString(),
      'updatedAt': api['updatedAt']?.toString(),
    };
  }

  // ── Field loading / local storage ─────────────────────────────────────────

  Future<bool> _loadFieldsFromApi(String categoryId) async {
    try {
      final rawFields = await _repository.fetchCategoryFields(categoryId);
      if (rawFields.isEmpty) return false;

      final mapped = rawFields.map(_mapApiFieldToInternal).toList();
      _apiFields = rawFields;
      _fieldsLoadedFromApi = true;
      _fields = mapped.map(_fieldFromJson).toList();

      await LocalCategoryStorage.saveFields(categoryId, mapped);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('CategoryProvider._loadFieldsFromApi: $e');
      return false;
    }
  }

  Future<bool> loadFieldsFromLocalStorage(String categoryId) async {
    if (await _loadFieldsFromApi(categoryId)) return true;

    try {
      final stored = await LocalCategoryStorage.getFields(categoryId);
      if (stored.isNotEmpty) {
        _apiFields = [];
        _fieldsLoadedFromApi = false;
        _fields = stored.map(_fieldFromJson).toList();
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('CategoryProvider: error reading local storage: $e');
    }

    _apiFields = [];
    _fieldsLoadedFromApi = false;
    _fields = List.from(_defaultFields);
    notifyListeners();

    try {
      await LocalCategoryStorage.saveFields(
        categoryId,
        _fields.map(_fieldToJson).toList(),
      );
    } catch (e) {
      debugPrint('CategoryProvider: error bootstrapping fields: $e');
    }
    return false;
  }

  Future<bool> saveFieldsToLocalStorage(String categoryId) async {
    try {
      return await LocalCategoryStorage.saveFields(
        categoryId,
        _fields.map(_fieldToJson).toList(),
      );
    } catch (e) {
      debugPrint('CategoryProvider: error saving fields: $e');
      return false;
    }
  }

  Future<bool> clearFieldsFromLocalStorage(String categoryId) async {
    try {
      return await LocalCategoryStorage.clearFields(categoryId);
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasFieldsInLocalStorage(String categoryId) async {
    try {
      return await LocalCategoryStorage.hasFields(categoryId);
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> getAllCategoriesWithStoredFields() async {
    try {
      return await LocalCategoryStorage.getAllCategoryIds();
    } catch (_) {
      return [];
    }
  }

  Future<bool> clearAllStoredFields() async {
    try {
      return await LocalCategoryStorage.clearAllFields();
    } catch (_) {
      return false;
    }
  }

  // ── Field API sync ────────────────────────────────────────────────────────

  Map<String, dynamic> _buildFieldVariable(FieldModel field) {
    final hasOptions =
        field.dropdownOptions != null && field.dropdownOptions!.isNotEmpty;
    return {
      'value': (field.defaultValue?.isNotEmpty ?? false)
          ? field.defaultValue
          : null,
      if (hasOptions) 'options': field.dropdownOptions,
    };
  }

  String? _infoText(FieldModel field) =>
      (field.defaultValue?.isNotEmpty ?? false) ? field.defaultValue : null;

  Future<void> _createField(String categoryId, FieldModel field) =>
      _repository.createCategoryField(
        categoryId: categoryId,
        labelText: field.labelText,
        fieldName: field.name,
        fieldType: field.fieldType,
        fieldVariable: _buildFieldVariable(field),
        isRequired: field.required,
        groupPermissions: field.permissions['create'] ?? 'Any',
        infoText: _infoText(field),
      );

  Future<void> _updateField(String categoryId, FieldModel field) =>
      _repository.updateCategoryField(
        categoryId: categoryId,
        fieldId: field.id,
        labelText: field.labelText,
        fieldName: field.name,
        fieldType: field.fieldType,
        fieldVariable: _buildFieldVariable(field),
        isRequired: field.required,
        groupPermissions: field.permissions['create'] ?? 'Any',
        infoText: _infoText(field),
        isArchive: field.isArchived,
      );

  Future<bool> _runFieldOps(
      Future<bool> Function(void Function(String key, Object error) onError) run,
      ) async {
    _isCreatingFields = true;
    _fieldCreationErrors = {};
    notifyListeners();

    final ok = await run((key, error) {
      _fieldCreationErrors[key] = error.toString();
    });

    _isCreatingFields = false;
    notifyListeners();
    return ok;
  }

  /// CREATE mode: posts every non-default, non-archived field.
  Future<bool> createCategoryFields(String categoryId) {
    final customFields = _fields
        .where((f) => !f.isArchived && !_defaultFieldTypes.contains(f.fieldType))
        .toList();
    if (customFields.isEmpty) return Future.value(true);

    return _runFieldOps((onError) async {
      var ok = true;
      for (final field in customFields) {
        try {
          await _createField(categoryId, field);
        } catch (e) {
          ok = false;
          onError(field.labelText, e);
        }
      }
      return ok;
    });
  }

  /// EDIT mode: diffs local fields against the server and deletes,
  /// updates or creates as needed.
  Future<bool> updateCategoryFields(String categoryId) {
    final serverIds = _apiFields
        .map((f) => f['fieldId']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();
    final localIds =
    _fields.map((f) => f.id).where((id) => id.isNotEmpty).toSet();

    return _runFieldOps((onError) async {
      var ok = true;

      for (final fieldId in serverIds.difference(localIds)) {
        try {
          await _repository.deleteCategoryField(
            categoryId: categoryId,
            fieldId: fieldId,
          );
        } catch (e) {
          ok = false;
          onError('delete:$fieldId', e);
        }
      }

      for (final field in _fields) {
        if (_defaultFieldTypes.contains(field.fieldType)) continue;

        final existsOnServer = serverIds.contains(field.id);
        if (field.isArchived && !existsOnServer) continue;

        try {
          if (existsOnServer) {
            await _updateField(categoryId, field);
          } else {
            await _createField(categoryId, field);
          }
        } catch (e) {
          ok = false;
          onError(field.labelText, e);
        }
      }

      return ok;
    });
  }

  // ── Categories ────────────────────────────────────────────────────────────

  GetCategoryModel? _categories;
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryItem> _allCategories = [];
  List<CategoryItem> _filteredCategories = [];
  List<CategoryItem> _flattenedCategories = [];
  final List<Category> _allDatum = [];

  GetCategoryModel? get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryItem> get filteredCategories => _filteredCategories;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => false;

  void _clearCategories() {
    _allCategories = [];
    _filteredCategories = [];
    _flattenedCategories = [];
  }

  Future<void> _cacheCategoryList(GetCategoryModel model) async {
    try {
      await LocalStorage.setString(
        _kCategoryListKey,
        jsonEncode(model.toJson()),
      );
    } catch (e) {
      debugPrint('CategoryProvider: failed to cache category list: $e');
    }
  }

  bool _loadCategoryListFromCache() {
    try {
      final raw = LocalStorage.getString(_kCategoryListKey);
      if (raw.isEmpty) return false;

      final model =
      GetCategoryModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (model.data == null || model.data!.isEmpty) return false;

      _categories = model;
      _allCategories = _buildCategoryHierarchy(model.data!);
      _filteredCategories = List.from(_allCategories);
      _updateFlattenedList();
      return true;
    } catch (e) {
      debugPrint('CategoryProvider: failed to load category cache: $e');
      return false;
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    _allDatum.clear();
    notifyListeners();

    try {
      final connectivity = await Connectivity().checkConnectivity();
      final isOnline = connectivity.any((r) => r != ConnectivityResult.none);

      if (!isOnline) {
        if (!_loadCategoryListFromCache()) {
          _errorMessage =
          'Offline — no cached categories available. Please connect and try again.';
          _clearCategories();
        }
        return;
      }

      // Fetch every page first; building the hierarchy from partial data
      // would show child categories as roots.
      final first = await _repository.fetchCategory(offset: 0, limit: _pageLimit);
      _categories = first;

      if (first.data == null) {
        _errorMessage = 'No categories found';
        _clearCategories();
        return;
      }

      _allDatum.addAll(first.data!);
      final total = first.pagination?.total ?? _allDatum.length;

      while (_allDatum.length < total) {
        final page = await _repository.fetchCategory(
          offset: _allDatum.length,
          limit: _pageLimit,
        );
        if (page.data == null || page.data!.isEmpty) break;
        _allDatum.addAll(page.data!);
      }

      _allCategories = _buildCategoryHierarchy(_allDatum);
      _filteredCategories = List.from(_allCategories);
      _updateFlattenedList();

      await _cacheCategoryList(first);
    } catch (e) {
      if (!_loadCategoryListFromCache()) {
        _errorMessage = e.toString();
        _categories = null;
        _clearCategories();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// No-op: all pages are fetched in [fetchCategories]. Kept for call-sites.
  Future<void> loadMoreCategories() async {}

  Future<void> refresh() => fetchCategories();

  // ── Category by ID ────────────────────────────────────────────────────────

  CreateCategoryModel? _categoryById;
  bool _isLoadingById = false;
  String? _errorMessageById;

  CreateCategoryModel? get categoryById => _categoryById;
  bool get isLoadingById => _isLoadingById;
  String? get errorMessageById => _errorMessageById;

  Future<void> fetchCategoryById(String categoryId) async {
    _isLoadingById = true;
    _errorMessageById = null;
    notifyListeners();

    try {
      _categoryById = await _repository.fetchCategoryById(categoryId);
      _canHaveChild = _categoryById?.data?.canHaveChildItems ?? false;
      _isWithdrawn = _categoryById?.data?.isWithdrawn ?? false;
      await loadFieldsFromLocalStorage(categoryId);
    } catch (e) {
      _errorMessageById = e.toString();
      _categoryById = null;
    } finally {
      _isLoadingById = false;
      notifyListeners();
    }
  }

  Map<String, String> getFormData() {
    final data = _categoryById?.data;
    if (data == null) return {};
    return {
      'categoryName': data.categoryName?.toString() ?? '',
      'categoryCode': data.categoryCode?.toString() ?? '',
      'description': data.description?.toString() ?? '',
      'descriptionTemplate': data.descriptionTemplate?.toString() ?? '',
      'instructions': data.instructions?.toString() ?? '',
      'notes': data.notes?.toString() ?? '',
      'replacementPeriod': data.replacementPeriod?.toString() ?? '',
    };
  }

  void clearCategoryById() {
    _categoryById = null;
    _errorMessageById = null;
    notifyListeners();
  }

  // ── Create / Update / Delete ──────────────────────────────────────────────

  bool _isCreating = false;
  String? _createErrorMessage;
  bool _isDeleting = false;

  bool get isCreating => _isCreating;
  String? get createErrorMessage => _createErrorMessage;
  bool get isDeleting => _isDeleting;

  String? _nullIfEmpty(String? value) =>
      (value == null || value.isEmpty) ? null : value;

  Future<bool> createCategory({
    String? categoryId,
    required String categoryName,
    required String categoryCode,
    required String description,
    required String descriptionTemplate,
    String? parentId,
    int? replacementPeriod,
    String? instructions,
    String? notes,
    bool canHaveChildItems = false,
    bool isWithdrawn = false,
    String? regulationId,
    String? checklistId,
    String? plannedMaintenanceId,
    bool saveFieldsToStorage = true,
  }) async {
    _isCreating = true;
    _createErrorMessage = null;
    _createdCategoryId = null;
    notifyListeners();

    final isUpdate = categoryId != null && categoryId.isNotEmpty;

    try {
      final String targetCategoryId;

      if (isUpdate) {
        await _repository.updateCategory(
          categoryId: categoryId,
          categoryName: categoryName,
          categoryCode: categoryCode,
          description: description,
          descriptionTemplate: descriptionTemplate,
          parentId: _nullIfEmpty(parentId),
          replacementPeriod: replacementPeriod ?? 0,
          instructions: _nullIfEmpty(instructions),
          notes: _nullIfEmpty(notes),
          canHaveChildItems: canHaveChildItems,
          isWithdrawn: isWithdrawn,
          regulationId: _nullIfEmpty(regulationId),
          checklistId: _nullIfEmpty(checklistId),
          plannedMaintenanceId: _nullIfEmpty(plannedMaintenanceId),
        );
        targetCategoryId = categoryId;
      } else {
        final response = await _repository.createCategory(
          categoryName: categoryName,
          categoryCode: categoryCode,
          description: description,
          descriptionTemplate: descriptionTemplate,
          parentId: _nullIfEmpty(parentId),
          replacementPeriod: replacementPeriod ?? 0,
          instructions: _nullIfEmpty(instructions),
          notes: _nullIfEmpty(notes),
          canHaveChildItems: canHaveChildItems,
          isWithdrawn: isWithdrawn,
          checklistId: _nullIfEmpty(checklistId),
          plannedMaintenanceId: _nullIfEmpty(plannedMaintenanceId),
        );
        targetCategoryId = response.data?.categoryId?.toString() ?? '';
        if (targetCategoryId.isNotEmpty) _createdCategoryId = targetCategoryId;
      }

      if (targetCategoryId.isNotEmpty) {
        if (saveFieldsToStorage) await saveFieldsToLocalStorage(targetCategoryId);

        if (isUpdate) {
          await updateCategoryFields(targetCategoryId);
        } else {
          await createCategoryFields(targetCategoryId);
        }
      }

      unawaited(fetchCategories());
      return true;
    } catch (e) {
      _createErrorMessage = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      _errorMessage = 'Invalid category ID';
      notifyListeners();
      return false;
    }

    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCategory(categoryId);
      await clearFieldsFromLocalStorage(categoryId);
      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  void clearCreateError() {
    _createErrorMessage = null;
    notifyListeners();
  }

  // ── Hierarchy ─────────────────────────────────────────────────────────────

  List<CategoryItem> _buildCategoryHierarchy(List<Category> apiData) {
    final map = <String, CategoryItem>{};
    final roots = <CategoryItem>[];

    for (final datum in apiData) {
      final id = datum.categoryId;
      if (id == null) continue;
      map[id] = CategoryItem(
        id: id,
        name: datum.categoryName ?? 'Unknown Category',
        parentId: datum.parentId?.toString(),
        canHaveChildItems: datum.canHaveChildItems ?? false,
        isWithdrawn: datum.isWithdrawn ?? false,
        categoryCode: datum.categoryCode,
        description: datum.description,
      );
    }

    for (final item in map.values) {
      final parent = (item.parentId == null || item.parentId!.isEmpty)
          ? null
          : map[item.parentId];

      if (parent == null) {
        item.level = 0;
        roots.add(item);
      } else {
        item.level = parent.level + 1;
        item.parentName = parent.name;
        parent.children.add(item);
      }
    }

    _sortChildrenRecursively(roots);
    return roots;
  }

  void _sortChildrenRecursively(List<CategoryItem> categories) {
    for (final category in categories) {
      if (category.children.isEmpty) continue;
      category.children.sort((a, b) => a.name.compareTo(b.name));
      _sortChildrenRecursively(category.children);
    }
  }

  void _updateFlattenedList() {
    _flattenedCategories = _flattenCategories(_filteredCategories);
  }

  List<CategoryItem> _flattenCategories(List<CategoryItem> categories) {
    final flattened = <CategoryItem>[];
    for (final category in categories) {
      flattened.add(category);
      if (category.isExpanded && category.children.isNotEmpty) {
        flattened.addAll(_flattenCategories(category.children));
      }
    }
    return flattened;
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void searchCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lower = query.toLowerCase();
      _filteredCategories = _allCategories
          .map((c) => _filterCategoryWithChildren(c, lower))
          .whereType<CategoryItem>()
          .toList();
    }
    _updateFlattenedList();
    notifyListeners();
  }

  CategoryItem? _filterCategoryWithChildren(
      CategoryItem category,
      String query,
      ) {
    final matches = category.name.toLowerCase().contains(query) ||
        (category.categoryCode?.toLowerCase().contains(query) ?? false);

    final filteredChildren = category.children
        .map((c) => _filterCategoryWithChildren(c, query))
        .whereType<CategoryItem>()
        .toList();

    if (!matches && filteredChildren.isEmpty) return null;

    return CategoryItem(
      id: category.id,
      name: category.name,
      parentId: category.parentId,
      parentName: category.parentName,
      canHaveChildItems: category.canHaveChildItems,
      isWithdrawn: category.isWithdrawn,
      categoryCode: category.categoryCode,
      description: category.description,
      level: category.level,
      isExpanded: filteredChildren.isNotEmpty || category.isExpanded,
      children: filteredChildren,
    );
  }

  // ── Expand / Collapse ─────────────────────────────────────────────────────

  void toggleExpansion(CategoryItem item) {
    _toggleExpansionRecursive(_allCategories, item.id);
    _filteredCategories = List.from(_allCategories);
    _updateFlattenedList();
    notifyListeners();
  }

  bool _toggleExpansionRecursive(
      List<CategoryItem> categories,
      String targetId,
      ) {
    for (final category in categories) {
      if (category.id == targetId) {
        category.isExpanded = !category.isExpanded;
        return true;
      }
      if (_toggleExpansionRecursive(category.children, targetId)) return true;
    }
    return false;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  int get totalItemCount => _flattenedCategories.length;

  int get withdrawnItemCount =>
      _flattenedCategories.where((c) => c.isWithdrawn).length;

  CategoryItem? getCategoryByIndex(int index) =>
      (index >= 0 && index < _flattenedCategories.length)
          ? _flattenedCategories[index]
          : null;

  void resetFormState() {
    _categoryById = null;
    _createErrorMessage = null;
    _errorMessageById = null;
    _canHaveChild = false;
    _isWithdrawn = false;
    _createdCategoryId = null;
    _fieldCreationErrors = {};
    _apiFields = [];
    _fieldsLoadedFromApi = false;
    _fields = List.from(_defaultFields);
    notifyListeners();
  }
}