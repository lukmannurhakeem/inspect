import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_model.freezed.dart';
part 'field_model.g.dart';

@freezed
abstract class FieldModel with _$FieldModel {
const factory FieldModel({
required String id,
required String labelText,
required String name,
required String fieldType,

@Default('')
String defaultValue,

@Default(false)
bool isReadOnly,

@Default('')
String section,

@Default(false)
bool required,

@Default(false)
bool isArchived,

@Default({
'create': 'Any',
'view': 'Any',
})
Map<String, String> permissions,

// Additional properties for different field types
List<String>? dropdownOptions,
String? fileExtension,
String? conditionalSource,
String? conditionalOperator,
String? conditionalValue,
double? minValue,
double? maxValue,
double? stepValue,
int? decimalPlaces,
}) = _FieldModel;

factory FieldModel.fromJson(Map<String, dynamic> json) =>
_$FieldModelFromJson(json);
}
