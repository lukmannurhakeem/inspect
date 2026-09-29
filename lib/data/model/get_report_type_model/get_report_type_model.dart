
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_report_type_model.freezed.dart';
part 'get_report_type_model.g.dart';

class SafeStringConverter implements JsonConverter<String?, dynamic> {
const SafeStringConverter();

@override
String? fromJson(dynamic value) {
if (value == null) return null;
if (value is String) return value.isEmpty ? null : value;
if (value is List) {
if (value.isEmpty) return null;
return value.map((e) => e?.toString() ?? '').join(',');
}
return value.toString();
}

@override
dynamic toJson(String? value) => value;
}

class SafeBoolConverter implements JsonConverter<bool?, dynamic> {
const SafeBoolConverter();

@override
bool? fromJson(dynamic value) {
if (value == null) return null;
if (value is bool) return value;
if (value is int) return value != 0;

final string = value.toString().toLowerCase();

if (string == 'true' || string == '1') return true;
if (string == 'false' || string == '0') return false;

return null;
}

@override
dynamic toJson(bool? value) => value;
}

class SafeDateTimeConverter implements JsonConverter<DateTime?, dynamic> {
const SafeDateTimeConverter();

@override
DateTime? fromJson(dynamic value) {
if (value == null) return null;

try {
return DateTime.parse(value.toString());
} catch (_) {
return null;
}
}

@override
dynamic toJson(DateTime? value) => value?.toIso8601String();
}

class SafeIntConverter implements JsonConverter<int?, dynamic> {
const SafeIntConverter();

@override
int? fromJson(dynamic value) {
if (value == null) return null;
if (value is int) return value;

return int.tryParse(value.toString());
}

@override
dynamic toJson(int? value) => value;
}

class SafeDoubleConverter implements JsonConverter<double?, dynamic> {
const SafeDoubleConverter();

@override
double? fromJson(dynamic value) {
if (value == null) return null;
if (value is num) return value.toDouble();

return double.tryParse(value.toString());
}

@override
dynamic toJson(double? value) => value;
}
@freezed
abstract class GetReportTypeModel with _$GetReportTypeModel {
  const factory GetReportTypeModel({
    List<ReportTypeItem>? data,
    @SafeStringConverter() String? message,
  }) = _GetReportTypeModel;

  factory GetReportTypeModel.fromJson(Map<String, dynamic> json) =>
      _$GetReportTypeModelFromJson(json);
}

@freezed
abstract class ReportTypeItem with _$ReportTypeItem {
  const factory ReportTypeItem({
    ReportType? reportType,
    List<CompetencyReport>? competencyReports,
    List<ReportTypeDate>? reportTypeDates,
    List<StatusRuleReport>? statusRuleReports,
    List<ReportField>? reportFields,
    List<ActionReport>? actionReports,
  }) = _ReportTypeItem;

  factory ReportTypeItem.fromJson(Map<String, dynamic> json) =>
      _$ReportTypeItemFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
const factory Datum({
ReportType? reportType,
List<CompetencyReport>? competencyReports,
List<ReportTypeDate>? reportTypeDates,
List<StatusRuleReport>? statusRuleReports,
List<ReportField>? reportFields,
List<ActionReport>? actionReports,
}) = _Datum;

factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
abstract class ReportType with _$ReportType {
const factory ReportType({
@JsonKey(name: 'reportTypeID')
@SafeStringConverter()
String? reportTypeId,

@JsonKey(name: 'jobID')
@SafeStringConverter()
String? jobId,

@SafeStringConverter()
String? reportName,

@SafeStringConverter()
String? description,

@SafeStringConverter()
String? documentCode,

@SafeBoolConverter()
bool? isExternalReport,

@SafeBoolConverter()
bool? defaultAsDraft,

@SafeBoolConverter()
bool? archived,

@SafeBoolConverter()
bool? updateItemStatus,

@SafeBoolConverter()
bool? updateItemDates,

@SafeStringConverter()
String? batchReportType,

@SafeBoolConverter()
bool? isStatusRequired,

@SafeStringConverter()
String? possibleStatus,

@SafeStringConverter()
String? possibleBatchStatus,

@SafeStringConverter()
String? permission,

@JsonKey(name: 'categoryID')
@SafeStringConverter()
String? categoryId,

@JsonKey(name: 'fieldsID')
@SafeStringConverter()
String? fieldsId,

@SafeStringConverter()
String? documentTemplate,

@SafeStringConverter()
String? labelTemplate,

@JsonKey(name: 'actionReportID')
@SafeStringConverter()
String? actionReportId,

@JsonKey(name: 'competencyID')
@SafeStringConverter()
String? competencyId,

@JsonKey(name: 'created_at')
@SafeDateTimeConverter()
DateTime? createdAt,

@JsonKey(name: 'updated_at')
@SafeDateTimeConverter()
DateTime? updatedAt,
}) = _ReportType;

factory ReportType.fromJson(Map<String, dynamic> json) =>
_$ReportTypeFromJson(json);
}

@freezed
abstract class ActionReport with _$ActionReport {
const factory ActionReport({
@JsonKey(name: 'actionReportID')
@SafeStringConverter()
String? actionReportId,

@JsonKey(name: 'reportTypeID')
@SafeStringConverter()
String? reportTypeId,

@SafeStringConverter()
String? description,

@SafeBoolConverter()
bool? isArchive,

@SafeStringConverter()
String? applyAction,

@SafeStringConverter()
String? match,

@SafeStringConverter()
String? actionType,

@SafeStringConverter()
String? sourceTable,

@SafeStringConverter()
String? sourceField,

@SafeStringConverter()
String? destinationTable,

@SafeStringConverter()
String? destinationField,

@JsonKey(name: 'created_at')
@SafeDateTimeConverter()
DateTime? createdAt,

@JsonKey(name: 'updated_at')
@SafeDateTimeConverter()
DateTime? updatedAt,
}) = _ActionReport;

factory ActionReport.fromJson(Map<String, dynamic> json) =>
_$ActionReportFromJson(json);
}

@freezed
abstract class CompetencyReport with _$CompetencyReport {
const factory CompetencyReport({
@JsonKey(name: 'competencyReportID')
@SafeStringConverter()
String? competencyReportId,

@JsonKey(name: 'reportTypeID')
@SafeStringConverter()
String? reportTypeId,

@SafeStringConverter()
String? internalExternal,

@SafeStringConverter()
String? name,

@SafeBoolConverter()
bool? canCreate,

@JsonKey(name: 'created_at')
@SafeDateTimeConverter()
DateTime? createdAt,

@JsonKey(name: 'updated_at')
@SafeDateTimeConverter()
DateTime? updatedAt,
}) = _CompetencyReport;

factory CompetencyReport.fromJson(Map<String, dynamic> json) =>
_$CompetencyReportFromJson(json);
}

@freezed
abstract class ReportField with _$ReportField {
const factory ReportField({
@JsonKey(name: 'reportFieldID')
@SafeStringConverter()
String? reportFieldId,

@JsonKey(name: 'reportTypeID')
@SafeStringConverter()
String? reportTypeId,

@SafeStringConverter()
String? labelText,

@SafeStringConverter()
String? name,

@SafeStringConverter()
String? fieldType,

dynamic defaultValue,

@SafeStringConverter()
String? section,

@SafeStringConverter()
String? onlyAvailable,

@SafeBoolConverter()
bool? isRequired,

@SafeStringConverter()
String? permissionField,

@SafeBoolConverter()
bool? doNotCopy,

@SafeStringConverter()
String? infoText,

@SafeBoolConverter()
bool? isArchive,

@JsonKey(name: 'created_at')
@SafeDateTimeConverter()
DateTime? createdAt,

@JsonKey(name: 'updated_at')
@SafeDateTimeConverter()
DateTime? updatedAt,
}) = _ReportField;

factory ReportField.fromJson(Map<String, dynamic> json) =>
_$ReportFieldFromJson(json);
}

@freezed
abstract class DefaultValueClass with _$DefaultValueClass {
const factory DefaultValueClass({
@SafeIntConverter()
int? max,

@SafeIntConverter()
int? min,

@SafeDoubleConverter()
double? step,

@SafeIntConverter()
int? value,

@SafeBoolConverter()
bool? isReadOnly,
}) = _DefaultValueClass;

factory DefaultValueClass.fromJson(Map<String, dynamic> json) =>
_$DefaultValueClassFromJson(json);
}

@freezed
abstract class ReportTypeDate with _$ReportTypeDate {
const factory ReportTypeDate({
@JsonKey(name: 'reportTypeDateID')
@SafeStringConverter()
String? reportTypeDateId,

@JsonKey(name: 'reportTypeID')
@SafeStringConverter()
String? reportTypeId,

@SafeStringConverter()
String? name,

@SafeStringConverter()
String? applyCycle,

@SafeBoolConverter()
bool? isRequired,

@SafeBoolConverter()
bool? disableFreeType,

@JsonKey(name: 'created_at')
@SafeDateTimeConverter()
DateTime? createdAt,

@JsonKey(name: 'updated_at')
@SafeDateTimeConverter()
DateTime? updatedAt,
}) = _ReportTypeDate;

factory ReportTypeDate.fromJson(Map<String, dynamic> json) =>
_$ReportTypeDateFromJson(json);
}

@freezed
abstract class StatusRuleReport with _$StatusRuleReport {
const factory StatusRuleReport({
@JsonKey(name: 'statusRuleReportID')
@SafeStringConverter()
String? statusRuleReportId,

@JsonKey(name: 'reportTypeID')
@SafeStringConverter()
String? reportTypeId,

@SafeStringConverter()
String? status,

@SafeStringConverter()
String? field,

@JsonKey(name: 'operator')
@SafeStringConverter()
String? statusRuleReportOperator,

@SafeStringConverter()
String? value,

@JsonKey(name: 'created_at')
@SafeDateTimeConverter()
DateTime? createdAt,

@JsonKey(name: 'updated_at')
@SafeDateTimeConverter()
DateTime? updatedAt,
}) = _StatusRuleReport;

factory StatusRuleReport.fromJson(Map<String, dynamic> json) =>
_$StatusRuleReportFromJson(json);
}

