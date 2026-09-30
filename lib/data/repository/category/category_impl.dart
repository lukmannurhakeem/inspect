import 'package:inspect/data/model/create_category_model/create_category_model.dart';
import 'package:inspect/data/model/get_category_model/get_category_model.dart';
import 'package:inspect/data/repository/category/category_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class CategoryImpl implements CategoryRepository {
  CategoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<GetCategoryModel> fetchCategory({
    int offset = 0,
    int limit = 50,
  }) async {
    final data = await _api.get<Map<String, dynamic>>(
      ApiEndpoint.categoryView,
      queryParameters: {'offset': offset, 'limit': limit},
    );
    return GetCategoryModel.fromJson(data);
  }

  @override
  Future<CreateCategoryModel> fetchCategoryById(String id) async {
    final data = await _api.get<Map<String, dynamic>>(
      ApiEndpoint.categoryViewById(categoryId: id),
    );
    return CreateCategoryModel.fromJson(data);
  }

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
    final data = await _api.post<Map<String, dynamic>>(
      ApiEndpoint.categoryCreate,
      data: _categoryBody(
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
      ),
    );
    return CreateCategoryModel.fromJson(data);
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
    final data = await _api.patch<Map<String, dynamic>>(
      ApiEndpoint.categoryUpdate(categoryId: categoryId),
      data: _categoryBody(
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
      ),
    );
    return CreateCategoryModel.fromJson(data);
  }

  @override
  Future<bool> deleteCategory(String categoryId) async {
    final data = await _api.delete<dynamic>(
      ApiEndpoint.categoryDelete(categoryId: categoryId),
    );
    return data is Map && data['success'] == true;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCategoryFields(
      String categoryId,
      ) async {
    final data = await _api.get<dynamic>(
      ApiEndpoint.categoryGetFields(categoryId: categoryId),
    );
    final fields = data is Map ? data['data'] : null;
    if (fields is! List) return [];

    return fields.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

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
  }) {
    return _api.post<dynamic>(
      ApiEndpoint.categoryCreateField(categoryId: categoryId),
      data: {
        'categoryID': categoryId,
        ..._fieldBody(
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
  }

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
  }) {
    return _api.patch<dynamic>(
      ApiEndpoint.categoryUpdateField(
        categoryId: categoryId,
        fieldId: fieldId,
      ),
      data: _fieldBody(
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
  }

  @override
  Future<void> deleteCategoryField({
    required String categoryId,
    required String fieldId,
  }) {
    return _api.delete<dynamic>(
      ApiEndpoint.categoryDeleteField(
        categoryId: categoryId,
        fieldId: fieldId,
      ),
    );
  }

  Map<String, dynamic> _categoryBody({
    required String? categoryName,
    required String? categoryCode,
    required String? description,
    required String? descriptionTemplate,
    required String? parentId,
    required int? replacementPeriod,
    required String? instructions,
    required String? notes,
    required bool canHaveChildItems,
    required bool isWithdrawn,
    String? regulationId,
    String? checklistId,
    String? plannedMaintenanceId,
  }) {
    return {
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
  }

  Map<String, dynamic> _fieldBody({
    required String labelText,
    required String fieldName,
    required String fieldType,
    required Map<String, dynamic> fieldVariable,
    required bool isRequired,
    required String groupPermissions,
    required bool doNotCopy,
    required String? infoText,
    required bool isArchive,
  }) {
    return {
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
}