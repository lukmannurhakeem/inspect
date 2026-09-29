import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_model.freezed.dart';
part 'cycle_model.g.dart';

@freezed
abstract class CycleModel with _$CycleModel {
  const CycleModel._();

  const factory CycleModel({
    List<CycleData>? data,
    String? message,
    int? page,
    int? pageSize,
    int? totalCount,
  }) = _CycleModel;

  factory CycleModel.fromJson(Map<String, dynamic> json) =>
      _$CycleModelFromJson(json);
}

@freezed
abstract class CycleData with _$CycleData {
  const CycleData._();

  const factory CycleData({
    @JsonKey(name: 'cycleID') String? cycleId,
    @JsonKey(name: 'reportTypeID') String? reportTypeId,
    String? reportTypeName,
    @JsonKey(name: 'categoryID') String? categoryId,
    @JsonKey(name: 'customerID') String? customerId,
    String? customerName,
    @JsonKey(name: 'siteID') String? siteId,
    String? unit,
    int? length,
    int? minLength,
    int? maxLength,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CycleData;

  factory CycleData.fromJson(Map<String, dynamic> json) =>
      _$CycleDataFromJson(json);

  /// "12 months"
  String? get cycleLength =>
      (length != null && unit != null) ? '$length $unit' : null;

  /// Falls back to categoryId.
  String? get categoryName => categoryId;

  /// "CustomerName / SiteId"
  String? get customerSite {
    final parts = [
      if (customerName?.isNotEmpty == true) customerName!,
      if (siteId?.isNotEmpty == true) siteId!,
    ];

    return parts.isNotEmpty ? parts.join(' / ') : null;
  }

  /// Report type name shown in the Data Type column.
  String? get dataType => reportTypeName;
}