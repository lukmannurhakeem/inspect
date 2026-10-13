import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_report_field_response.freezed.dart';
part 'delete_report_field_response.g.dart';

@freezed
abstract class DeleteReportFieldResponse with _$DeleteReportFieldResponse {
  const factory DeleteReportFieldResponse({
    required String message,
  }) = _DeleteReportFieldResponse;

  factory DeleteReportFieldResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteReportFieldResponseFromJson(json);
}