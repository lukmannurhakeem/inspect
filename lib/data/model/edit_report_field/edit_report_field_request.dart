import 'package:freezed_annotation/freezed_annotation.dart';
import 'report_field_default_value.dart';

part 'edit_report_field_request.freezed.dart';
part 'edit_report_field_request.g.dart';
@freezed
abstract class EditReportFieldRequest with _$EditReportFieldRequest {
  @JsonSerializable(includeIfNull: false)
  const factory EditReportFieldRequest({
    String? reportTypeID,
    String? labelText,
    String? name,
    String? fieldType,
    ReportFieldDefaultValue? defaultValue,
    String? onlyAvailable,
    bool? isRequired,
    bool? doNotCopy,
    bool? isArchive,
  }) = _EditReportFieldRequest;

  factory EditReportFieldRequest.fromJson(Map<String, dynamic> json) =>
      _$EditReportFieldRequestFromJson(json);
}
