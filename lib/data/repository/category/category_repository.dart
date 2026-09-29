import 'package:inspect/data/model/create_category_model/create_category_model.dart';
import 'package:inspect/data/model/get_category_model/get_category_model.dart';

abstract class CategoryRepository {
  Future<GetCategoryModel> fetchCategory({int offset = 0, int limit = 50});

  Future<CreateCategoryModel> fetchCategoryById(String id);

  Future<CreateCategoryModel> createCategory({
    String? categoryName,
    String? categoryCode,
    String? description,
    String? descriptionTemplate,
    String? parentId,
    int? replacementPeriod,
    String? instructions,
    String? notes,
    bool canHaveChildItems,
    bool isWithdrawn,
    String? checklistId,
    String? plannedMaintenanceId,
  });

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
    bool canHaveChildItems,
    bool isWithdrawn,
    String? regulationId,
    String? checklistId,
    String? plannedMaintenanceId,
  });

  Future<bool> deleteCategory(String categoryId);

  Future<List<Map<String, dynamic>>> fetchCategoryFields(String categoryId);

  Future<void> createCategoryField({
    required String categoryId,
    required String labelText,
    required String fieldName,
    required String fieldType,
    required Map<String, dynamic> fieldVariable,
    required bool isRequired,
    required String groupPermissions,
    bool doNotCopy,
    String? infoText,
    bool isArchive,
  });

  Future<void> updateCategoryField({
    required String categoryId,
    required String fieldId,
    required String labelText,
    required String fieldName,
    required String fieldType,
    required Map<String, dynamic> fieldVariable,
    required bool isRequired,
    required String groupPermissions,
    bool doNotCopy,
    String? infoText,
    bool isArchive,
  });

  Future<void> deleteCategoryField({
    required String categoryId,
    required String fieldId,
  });
}
