import 'package:freezed_annotation/freezed_annotation.dart';
import 'report_field_default_value.dart';

part 'edit_report_field_response.freezed.dart';
part 'edit_report_field_response.g.dart';


@freezed
abstract class EditReportFieldResponse with _$EditReportFieldResponse {
  const factory EditReportFieldResponse({
    required ReportFieldData data,
    required String message,
  }) = _EditReportFieldResponse;

  factory EditReportFieldResponse.fromJson(Map<String, dynamic> json) =>
      _$EditReportFieldResponseFromJson(json);
}

@freezed
abstract class ReportFieldData with _$ReportFieldData {
  const factory ReportFieldData({
    required String reportFieldID,
    required String reportTypeID,
    required String labelText,
    required String name,
    required String fieldType,
    ReportFieldDefaultValue? defaultValue,
    String? onlyAvailable,
    @Default(false) bool isRequired,
    @Default(false) bool doNotCopy,
    @Default(false) bool isArchive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ReportFieldData;

  factory ReportFieldData.fromJson(Map<String, dynamic> json) =>
      _$ReportFieldDataFromJson(json);
}