import 'package:inspect/data/model/create_category_model/create_category_model.dart';
import 'package:inspect/data/model/get_category_model/get_category_model.dart';
import 'package:inspect/data/repository/category/category_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class CategoryImpl implements CategoryRepository {
  final ApiClient _api;

  CategoryImpl(this._api);

  @override
  Future<GetCategoryModel> fetchCategory({
    int offset = 0,
    int limit = 50,
  }) => _api.get(
    ApiEndpoint.categoryView,
    queryParameters: {'offset': offset, 'limit': limit},
    parser: (data) =>
        GetCategoryModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<CreateCategoryModel> createCategory({
    String? categoryName,
    String? categoryCode,
    String? description,
    String? descriptionTemplate,
    String? parentId,
    int? replacementPeriod,
    String? instructions,
    String? notes,
    bool canHaveChildItems = false,
    bool isWithdrawn = false,
    String? checklistId,
    String? plannedMaintenanceId,
  }) async {
    final payload = _payload(
      categoryName: categoryName,
      categoryCode: categoryCode,
      description: description,
      descriptionTemplate: descriptionTemplate,
      parentId: parentId,
      replacementPeriod: replacementPeriod,
      instructions: instructions,
      notes: notes,
      canHaveChildItems: canHaveChildItems,
      isWithdrawn: isWithdrawn,
      checklistId: checklistId,
      plannedMaintenanceId: plannedMaintenanceId,
    );

    final data = await _api.post<dynamic>(
      ApiEndpoint.categoryCreate,
      data: payload,
    );

    if (_isQueued(data)) {
      return _queuedModel(
        {
          'categoryId': 'temp_${DateTime.now().millisecondsSinceEpoch}',
          ...payload,
        },
        'Category saved locally. Will sync when online.',
      );
    }

    return CreateCategoryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<CreateCategoryModel> updateCategory({
    required String categoryId,
    String? categoryName,
    String? categoryCode,
    String? description,
    String? descriptionTemplate,
    String? parentId,
    int? replacementPeriod,
    String? instructions,
    String? notes,
    bool canHaveChildItems = false,
    bool isWithdrawn = false,
    String? regulationId,
    String? checklistId,
    String? plannedMaintenanceId,
  }) async {
    final payload = _payload(
      categoryName: categoryName,
      categoryCode: categoryCode,
      description: description,
      descriptionTemplate: descriptionTemplate,
      parentId: parentId,
      replacementPeriod: replacementPeriod,
      instructions: instructions,
      notes: notes,
      canHaveChildItems: canHaveChildItems,
      isWithdrawn: isWithdrawn,
      regulationId: regulationId,
      checklistId: checklistId,
      plannedMaintenanceId: plannedMaintenanceId,
    );

    final data = await _api.patch<dynamic>(
      ApiEndpoint.categoryUpdate(categoryId: categoryId),
      data: payload,
    );

    if (_isQueued(data)) {
      return _queuedModel(
        {'categoryId': categoryId, ...payload},
        'Category update queued. Will sync when online.',
      );
    }

    return CreateCategoryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<CreateCategoryModel> fetchCategoryById(String id) => _api.get(
    ApiEndpoint.categoryViewById(categoryId: id),
    parser: (data) =>
        CreateCategoryModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<bool> deleteCategory(String categoryId) async {
    final data = await _api.delete<dynamic>(
      ApiEndpoint.categoryDelete(categoryId: categoryId),
    );

    if (_isQueued(data)) return true;
    return data is Map && data['success'] == true;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCategoryFields(String categoryId) =>
      _api.get(
        ApiEndpoint.categoryGetFields(categoryId: categoryId),
        parser: (data) {
          if (data is Map && data['data'] is List) {
            return (data['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          }
          return <Map<String, dynamic>>[];
        },
      );

  @override
  Future<void> createCategoryField({
    required String categoryId,
    required String labelText,
    required String fieldName,
    required String fieldType,
    required Map<String, dynamic> fieldVariable,
    required bool isRequired,
    required String groupPermissions,
    bool doNotCopy = false,
    String? infoText,
    bool isArchive = false,
  }) => _api.post<dynamic>(
    ApiEndpoint.categoryCreateField(categoryId: categoryId),
    data: {
      'categoryID': categoryId,
      ..._fieldPayload(
        labelText: labelText,
        fieldName: fieldName,
        fieldType: fieldType,
        fieldVariable: fieldVariable,
        isRequired: isRequired,
        groupPermissions: groupPermissions,
        doNotCopy: doNotCopy,
        infoText: infoText,
        isArchive: isArchive,
      ),
    },
  );

  @override
  Future<void> updateCategoryField({
    required String categoryId,
    required String fieldId,
    required String labelText,
    required String fieldName,
    required String fieldType,
    required Map<String, dynamic> fieldVariable,
    required bool isRequired,
    required String groupPermissions,
    bool doNotCopy = false,
    String? infoText,
    bool isArchive = false,
  }) => _api.patch<dynamic>(
    ApiEndpoint.categoryUpdateField(
      categoryId: categoryId,
      fieldId: fieldId,
    ),
    data: _fieldPayload(
      labelText: labelText,
      fieldName: fieldName,
      fieldType: fieldType,
      fieldVariable: fieldVariable,
      isRequired: isRequired,
      groupPermissions: groupPermissions,
      doNotCopy: doNotCopy,
      infoText: infoText,
      isArchive: isArchive,
    ),
  );

  @override
  Future<void> deleteCategoryField({
    required String categoryId,
    required String fieldId,
  }) => _api.delete<dynamic>(
    ApiEndpoint.categoryDeleteField(
      categoryId: categoryId,
      fieldId: fieldId,
    ),
  );

  bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

  CreateCategoryModel _queuedModel(
      Map<String, dynamic> fields,
      String message,
      ) => CreateCategoryModel.fromJson({
    'data': {...fields, 'isQueued': true},
    'message': message,
  });

  Map<String, dynamic> _payload({
    String? categoryName,
    String? categoryCode,
    String? description,
    String? descriptionTemplate,
    String? parentId,
    int? replacementPeriod,
    String? instructions,
    String? notes,
    required bool canHaveChildItems,
    required bool isWithdrawn,
    String? regulationId,
    String? checklistId,
    String? plannedMaintenanceId,
  }) => {
    'categoryName': categoryName,
    'categoryCode': categoryCode,
    'description': description,
    'descriptionTemplate': descriptionTemplate,
    'replacementPeriod': replacementPeriod,
    'canHaveChildItems': canHaveChildItems,
    'isWithdrawn': isWithdrawn,
    if (instructions != null) 'instructions': instructions,
    if (notes != null) 'notes': notes,
    if (regulationId != null) 'regulationId': regulationId,
    if (checklistId != null) 'checklistId': checklistId,
    if (plannedMaintenanceId != null)
      'plannedMaintenanceId': plannedMaintenanceId,
    if (parentId != null && parentId.isNotEmpty) 'parentId': parentId,
  };

  Map<String, dynamic> _fieldPayload({
    required String labelText,
    required String fieldName,
    required String fieldType,
    required Map<String, dynamic> fieldVariable,
    required bool isRequired,
    required String groupPermissions,
    required bool doNotCopy,
    String? infoText,
    required bool isArchive,
  }) => {
    'labelText': labelText,
    'fieldName': fieldName,
    'fieldType': fieldType,
    'fieldVariable': fieldVariable,
    'isRequired': isRequired,
    'groupPermissions': groupPermissions,
    'doNotCopy': doNotCopy,
    if (infoText != null) 'infoText': infoText,
    'isArchive': isArchive,
  };
}