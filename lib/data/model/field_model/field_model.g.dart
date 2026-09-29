// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldModel _$FieldModelFromJson(Map<String, dynamic> json) => _FieldModel(
  id: json['id'] as String,
  labelText: json['labelText'] as String,
  name: json['name'] as String,
  fieldType: json['fieldType'] as String,
  defaultValue: json['defaultValue'] as String? ?? '',
  isReadOnly: json['isReadOnly'] as bool? ?? false,
  section: json['section'] as String? ?? '',
  required: json['required'] as bool? ?? false,
  isArchived: json['isArchived'] as bool? ?? false,
  permissions:
      (json['permissions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {'create': 'Any', 'view': 'Any'},
  dropdownOptions: (json['dropdownOptions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  fileExtension: json['fileExtension'] as String?,
  conditionalSource: json['conditionalSource'] as String?,
  conditionalOperator: json['conditionalOperator'] as String?,
  conditionalValue: json['conditionalValue'] as String?,
  minValue: (json['minValue'] as num?)?.toDouble(),
  maxValue: (json['maxValue'] as num?)?.toDouble(),
  stepValue: (json['stepValue'] as num?)?.toDouble(),
  decimalPlaces: (json['decimalPlaces'] as num?)?.toInt(),
);

Map<String, dynamic> _$FieldModelToJson(_FieldModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'labelText': instance.labelText,
      'name': instance.name,
      'fieldType': instance.fieldType,
      'defaultValue': instance.defaultValue,
      'isReadOnly': instance.isReadOnly,
      'section': instance.section,
      'required': instance.required,
      'isArchived': instance.isArchived,
      'permissions': instance.permissions,
      'dropdownOptions': instance.dropdownOptions,
      'fileExtension': instance.fileExtension,
      'conditionalSource': instance.conditionalSource,
      'conditionalOperator': instance.conditionalOperator,
      'conditionalValue': instance.conditionalValue,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'stepValue': instance.stepValue,
      'decimalPlaces': instance.decimalPlaces,
    };
