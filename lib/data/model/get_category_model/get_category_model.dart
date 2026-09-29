
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_category_model.freezed.dart';
part 'get_category_model.g.dart';

@freezed
abstract class GetCategoryModel with _$GetCategoryModel {
const factory GetCategoryModel({
@Default([])
List<Category> data,

String? message,

Pagination? pagination,

bool? success,
}) = _GetCategoryModel;

factory GetCategoryModel.fromJson(Map<String, dynamic> json) =>
_$GetCategoryModelFromJson(json);
}

@freezed
abstract class Category with _$Category {
const factory Category({
String? categoryId,

dynamic parentId,

String? categoryName,

String? categoryCode,

String? description,

String? descriptionTemplate,

int? replacementPeriod,

String? instructions,

String? notes,

bool? canHaveChildItems,

bool? isWithdrawn,

DateTime? createdAt,

DateTime? updatedAt,

String? siteId,

String? regulationId,

String? checklistId,

String? plannedMaintenanceId,
}) = _Category;

factory Category.fromJson(Map<String, dynamic> json) =>
_$CategoryFromJson(json);
}

@freezed
abstract class Pagination with _$Pagination {
const factory Pagination({
int? count,

int? limit,

int? offset,

int? total,
}) = _Pagination;

factory Pagination.fromJson(Map<String, dynamic> json) =>
_$PaginationFromJson(json);
}
