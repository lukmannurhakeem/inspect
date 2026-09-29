import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_model.freezed.dart';
part 'create_category_model.g.dart';

@freezed
abstract class CreateCategoryModel with _$CreateCategoryModel {
  const CreateCategoryModel._();

  const factory CreateCategoryModel({
    Data? data,
    String? message,
    bool? success,
  }) = _CreateCategoryModel;

  factory CreateCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryModelFromJson(json);

  factory CreateCategoryModel.fromRawJson(String str) =>
      CreateCategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

@freezed
abstract class Data with _$Data {
  const Data._();

  const factory Data({
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
    String? regulationId,
    String? checklistId,
    String? plannedMaintenanceId,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  factory Data.fromRawJson(String str) =>
      Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}