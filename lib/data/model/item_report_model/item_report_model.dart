import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_report_model.freezed.dart';
part 'item_report_model.g.dart';

@freezed
abstract class ItemReportModel with _$ItemReportModel {
  const factory ItemReportModel({
    @JsonKey(name: 'reportID') String? reportId,
    @JsonKey(name: 'reportTypeID') String? reportTypeId,
    String? reportName,
    @JsonKey(name: 'itemID') String? itemId,
    String? itemNo,
    String? status,
    String? inspectedBy,
    DateTime? reportDate,
    String? regulation,
    ReportData? reportData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ItemReportModel;

  factory ItemReportModel.fromJson(Map<String, dynamic> json) =>
      _$ItemReportModelFromJson(json);
}

@freezed
abstract class ReportData with _$ReportData {
  const factory ReportData({
    Field? field1,
    Field? field2,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
}

@freezed
abstract class Field with _$Field {
  const factory Field({
    String? value,
  }) = _Field;

  factory Field.fromJson(Map<String, dynamic> json) =>
      _$FieldFromJson(json);
}
