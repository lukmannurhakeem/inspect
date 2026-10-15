import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_field_default_value.freezed.dart';
part 'report_field_default_value.g.dart';

@freezed
abstract class ReportFieldDefaultValue with _$ReportFieldDefaultValue {
  // Keep nulls: {"value": null, "isReadOnly": false} must be sent as-is
  @JsonSerializable(includeIfNull: true)
  const factory ReportFieldDefaultValue({
    dynamic value,
    @Default(false) bool isReadOnly,
  }) = _ReportFieldDefaultValue;

  factory ReportFieldDefaultValue.fromJson(Map<String, dynamic> json) =>
      _$ReportFieldDefaultValueFromJson(json);
}