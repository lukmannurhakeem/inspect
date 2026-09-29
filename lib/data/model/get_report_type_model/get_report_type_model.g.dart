// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_report_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetReportTypeModel _$GetReportTypeModelFromJson(Map<String, dynamic> json) =>
    _GetReportTypeModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReportTypeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: const SafeStringConverter().fromJson(json['message']),
    );

Map<String, dynamic> _$GetReportTypeModelToJson(_GetReportTypeModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': const SafeStringConverter().toJson(instance.message),
    };

_ReportTypeItem _$ReportTypeItemFromJson(Map<String, dynamic> json) =>
    _ReportTypeItem(
      reportType: json['reportType'] == null
          ? null
          : ReportType.fromJson(json['reportType'] as Map<String, dynamic>),
      competencyReports: (json['competencyReports'] as List<dynamic>?)
          ?.map((e) => CompetencyReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportTypeDates: (json['reportTypeDates'] as List<dynamic>?)
          ?.map((e) => ReportTypeDate.fromJson(e as Map<String, dynamic>))
          .toList(),
      statusRuleReports: (json['statusRuleReports'] as List<dynamic>?)
          ?.map((e) => StatusRuleReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportFields: (json['reportFields'] as List<dynamic>?)
          ?.map((e) => ReportField.fromJson(e as Map<String, dynamic>))
          .toList(),
      actionReports: (json['actionReports'] as List<dynamic>?)
          ?.map((e) => ActionReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportTypeItemToJson(_ReportTypeItem instance) =>
    <String, dynamic>{
      'reportType': instance.reportType,
      'competencyReports': instance.competencyReports,
      'reportTypeDates': instance.reportTypeDates,
      'statusRuleReports': instance.statusRuleReports,
      'reportFields': instance.reportFields,
      'actionReports': instance.actionReports,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  reportType: json['reportType'] == null
      ? null
      : ReportType.fromJson(json['reportType'] as Map<String, dynamic>),
  competencyReports: (json['competencyReports'] as List<dynamic>?)
      ?.map((e) => CompetencyReport.fromJson(e as Map<String, dynamic>))
      .toList(),
  reportTypeDates: (json['reportTypeDates'] as List<dynamic>?)
      ?.map((e) => ReportTypeDate.fromJson(e as Map<String, dynamic>))
      .toList(),
  statusRuleReports: (json['statusRuleReports'] as List<dynamic>?)
      ?.map((e) => StatusRuleReport.fromJson(e as Map<String, dynamic>))
      .toList(),
  reportFields: (json['reportFields'] as List<dynamic>?)
      ?.map((e) => ReportField.fromJson(e as Map<String, dynamic>))
      .toList(),
  actionReports: (json['actionReports'] as List<dynamic>?)
      ?.map((e) => ActionReport.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
  'reportType': instance.reportType,
  'competencyReports': instance.competencyReports,
  'reportTypeDates': instance.reportTypeDates,
  'statusRuleReports': instance.statusRuleReports,
  'reportFields': instance.reportFields,
  'actionReports': instance.actionReports,
};

_ReportType _$ReportTypeFromJson(Map<String, dynamic> json) => _ReportType(
  reportTypeId: const SafeStringConverter().fromJson(json['reportTypeID']),
  jobId: const SafeStringConverter().fromJson(json['jobID']),
  reportName: const SafeStringConverter().fromJson(json['reportName']),
  description: const SafeStringConverter().fromJson(json['description']),
  documentCode: const SafeStringConverter().fromJson(json['documentCode']),
  isExternalReport: const SafeBoolConverter().fromJson(
    json['isExternalReport'],
  ),
  defaultAsDraft: const SafeBoolConverter().fromJson(json['defaultAsDraft']),
  archived: const SafeBoolConverter().fromJson(json['archived']),
  updateItemStatus: const SafeBoolConverter().fromJson(
    json['updateItemStatus'],
  ),
  updateItemDates: const SafeBoolConverter().fromJson(json['updateItemDates']),
  batchReportType: const SafeStringConverter().fromJson(
    json['batchReportType'],
  ),
  isStatusRequired: const SafeBoolConverter().fromJson(
    json['isStatusRequired'],
  ),
  possibleStatus: const SafeStringConverter().fromJson(json['possibleStatus']),
  possibleBatchStatus: const SafeStringConverter().fromJson(
    json['possibleBatchStatus'],
  ),
  permission: const SafeStringConverter().fromJson(json['permission']),
  categoryId: const SafeStringConverter().fromJson(json['categoryID']),
  fieldsId: const SafeStringConverter().fromJson(json['fieldsID']),
  documentTemplate: const SafeStringConverter().fromJson(
    json['documentTemplate'],
  ),
  labelTemplate: const SafeStringConverter().fromJson(json['labelTemplate']),
  actionReportId: const SafeStringConverter().fromJson(json['actionReportID']),
  competencyId: const SafeStringConverter().fromJson(json['competencyID']),
  createdAt: const SafeDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const SafeDateTimeConverter().fromJson(json['updated_at']),
);

Map<String, dynamic> _$ReportTypeToJson(
  _ReportType instance,
) => <String, dynamic>{
  'reportTypeID': const SafeStringConverter().toJson(instance.reportTypeId),
  'jobID': const SafeStringConverter().toJson(instance.jobId),
  'reportName': const SafeStringConverter().toJson(instance.reportName),
  'description': const SafeStringConverter().toJson(instance.description),
  'documentCode': const SafeStringConverter().toJson(instance.documentCode),
  'isExternalReport': const SafeBoolConverter().toJson(
    instance.isExternalReport,
  ),
  'defaultAsDraft': const SafeBoolConverter().toJson(instance.defaultAsDraft),
  'archived': const SafeBoolConverter().toJson(instance.archived),
  'updateItemStatus': const SafeBoolConverter().toJson(
    instance.updateItemStatus,
  ),
  'updateItemDates': const SafeBoolConverter().toJson(instance.updateItemDates),
  'batchReportType': const SafeStringConverter().toJson(
    instance.batchReportType,
  ),
  'isStatusRequired': const SafeBoolConverter().toJson(
    instance.isStatusRequired,
  ),
  'possibleStatus': const SafeStringConverter().toJson(instance.possibleStatus),
  'possibleBatchStatus': const SafeStringConverter().toJson(
    instance.possibleBatchStatus,
  ),
  'permission': const SafeStringConverter().toJson(instance.permission),
  'categoryID': const SafeStringConverter().toJson(instance.categoryId),
  'fieldsID': const SafeStringConverter().toJson(instance.fieldsId),
  'documentTemplate': const SafeStringConverter().toJson(
    instance.documentTemplate,
  ),
  'labelTemplate': const SafeStringConverter().toJson(instance.labelTemplate),
  'actionReportID': const SafeStringConverter().toJson(instance.actionReportId),
  'competencyID': const SafeStringConverter().toJson(instance.competencyId),
  'created_at': const SafeDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const SafeDateTimeConverter().toJson(instance.updatedAt),
};

_ActionReport _$ActionReportFromJson(Map<String, dynamic> json) =>
    _ActionReport(
      actionReportId: const SafeStringConverter().fromJson(
        json['actionReportID'],
      ),
      reportTypeId: const SafeStringConverter().fromJson(json['reportTypeID']),
      description: const SafeStringConverter().fromJson(json['description']),
      isArchive: const SafeBoolConverter().fromJson(json['isArchive']),
      applyAction: const SafeStringConverter().fromJson(json['applyAction']),
      match: const SafeStringConverter().fromJson(json['match']),
      actionType: const SafeStringConverter().fromJson(json['actionType']),
      sourceTable: const SafeStringConverter().fromJson(json['sourceTable']),
      sourceField: const SafeStringConverter().fromJson(json['sourceField']),
      destinationTable: const SafeStringConverter().fromJson(
        json['destinationTable'],
      ),
      destinationField: const SafeStringConverter().fromJson(
        json['destinationField'],
      ),
      createdAt: const SafeDateTimeConverter().fromJson(json['created_at']),
      updatedAt: const SafeDateTimeConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$ActionReportToJson(
  _ActionReport instance,
) => <String, dynamic>{
  'actionReportID': const SafeStringConverter().toJson(instance.actionReportId),
  'reportTypeID': const SafeStringConverter().toJson(instance.reportTypeId),
  'description': const SafeStringConverter().toJson(instance.description),
  'isArchive': const SafeBoolConverter().toJson(instance.isArchive),
  'applyAction': const SafeStringConverter().toJson(instance.applyAction),
  'match': const SafeStringConverter().toJson(instance.match),
  'actionType': const SafeStringConverter().toJson(instance.actionType),
  'sourceTable': const SafeStringConverter().toJson(instance.sourceTable),
  'sourceField': const SafeStringConverter().toJson(instance.sourceField),
  'destinationTable': const SafeStringConverter().toJson(
    instance.destinationTable,
  ),
  'destinationField': const SafeStringConverter().toJson(
    instance.destinationField,
  ),
  'created_at': const SafeDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const SafeDateTimeConverter().toJson(instance.updatedAt),
};

_CompetencyReport _$CompetencyReportFromJson(Map<String, dynamic> json) =>
    _CompetencyReport(
      competencyReportId: const SafeStringConverter().fromJson(
        json['competencyReportID'],
      ),
      reportTypeId: const SafeStringConverter().fromJson(json['reportTypeID']),
      internalExternal: const SafeStringConverter().fromJson(
        json['internalExternal'],
      ),
      name: const SafeStringConverter().fromJson(json['name']),
      canCreate: const SafeBoolConverter().fromJson(json['canCreate']),
      createdAt: const SafeDateTimeConverter().fromJson(json['created_at']),
      updatedAt: const SafeDateTimeConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$CompetencyReportToJson(_CompetencyReport instance) =>
    <String, dynamic>{
      'competencyReportID': const SafeStringConverter().toJson(
        instance.competencyReportId,
      ),
      'reportTypeID': const SafeStringConverter().toJson(instance.reportTypeId),
      'internalExternal': const SafeStringConverter().toJson(
        instance.internalExternal,
      ),
      'name': const SafeStringConverter().toJson(instance.name),
      'canCreate': const SafeBoolConverter().toJson(instance.canCreate),
      'created_at': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updated_at': const SafeDateTimeConverter().toJson(instance.updatedAt),
    };

_ReportField _$ReportFieldFromJson(Map<String, dynamic> json) => _ReportField(
  reportFieldId: const SafeStringConverter().fromJson(json['reportFieldID']),
  reportTypeId: const SafeStringConverter().fromJson(json['reportTypeID']),
  labelText: const SafeStringConverter().fromJson(json['labelText']),
  name: const SafeStringConverter().fromJson(json['name']),
  fieldType: const SafeStringConverter().fromJson(json['fieldType']),
  defaultValue: json['defaultValue'],
  section: const SafeStringConverter().fromJson(json['section']),
  onlyAvailable: const SafeStringConverter().fromJson(json['onlyAvailable']),
  isRequired: const SafeBoolConverter().fromJson(json['isRequired']),
  permissionField: const SafeStringConverter().fromJson(
    json['permissionField'],
  ),
  doNotCopy: const SafeBoolConverter().fromJson(json['doNotCopy']),
  infoText: const SafeStringConverter().fromJson(json['infoText']),
  isArchive: const SafeBoolConverter().fromJson(json['isArchive']),
  createdAt: const SafeDateTimeConverter().fromJson(json['created_at']),
  updatedAt: const SafeDateTimeConverter().fromJson(json['updated_at']),
);

Map<String, dynamic> _$ReportFieldToJson(
  _ReportField instance,
) => <String, dynamic>{
  'reportFieldID': const SafeStringConverter().toJson(instance.reportFieldId),
  'reportTypeID': const SafeStringConverter().toJson(instance.reportTypeId),
  'labelText': const SafeStringConverter().toJson(instance.labelText),
  'name': const SafeStringConverter().toJson(instance.name),
  'fieldType': const SafeStringConverter().toJson(instance.fieldType),
  'defaultValue': instance.defaultValue,
  'section': const SafeStringConverter().toJson(instance.section),
  'onlyAvailable': const SafeStringConverter().toJson(instance.onlyAvailable),
  'isRequired': const SafeBoolConverter().toJson(instance.isRequired),
  'permissionField': const SafeStringConverter().toJson(
    instance.permissionField,
  ),
  'doNotCopy': const SafeBoolConverter().toJson(instance.doNotCopy),
  'infoText': const SafeStringConverter().toJson(instance.infoText),
  'isArchive': const SafeBoolConverter().toJson(instance.isArchive),
  'created_at': const SafeDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const SafeDateTimeConverter().toJson(instance.updatedAt),
};

_DefaultValueClass _$DefaultValueClassFromJson(Map<String, dynamic> json) =>
    _DefaultValueClass(
      max: const SafeIntConverter().fromJson(json['max']),
      min: const SafeIntConverter().fromJson(json['min']),
      step: const SafeDoubleConverter().fromJson(json['step']),
      value: const SafeIntConverter().fromJson(json['value']),
      isReadOnly: const SafeBoolConverter().fromJson(json['isReadOnly']),
    );

Map<String, dynamic> _$DefaultValueClassToJson(_DefaultValueClass instance) =>
    <String, dynamic>{
      'max': const SafeIntConverter().toJson(instance.max),
      'min': const SafeIntConverter().toJson(instance.min),
      'step': const SafeDoubleConverter().toJson(instance.step),
      'value': const SafeIntConverter().toJson(instance.value),
      'isReadOnly': const SafeBoolConverter().toJson(instance.isReadOnly),
    };

_ReportTypeDate _$ReportTypeDateFromJson(Map<String, dynamic> json) =>
    _ReportTypeDate(
      reportTypeDateId: const SafeStringConverter().fromJson(
        json['reportTypeDateID'],
      ),
      reportTypeId: const SafeStringConverter().fromJson(json['reportTypeID']),
      name: const SafeStringConverter().fromJson(json['name']),
      applyCycle: const SafeStringConverter().fromJson(json['applyCycle']),
      isRequired: const SafeBoolConverter().fromJson(json['isRequired']),
      disableFreeType: const SafeBoolConverter().fromJson(
        json['disableFreeType'],
      ),
      createdAt: const SafeDateTimeConverter().fromJson(json['created_at']),
      updatedAt: const SafeDateTimeConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$ReportTypeDateToJson(
  _ReportTypeDate instance,
) => <String, dynamic>{
  'reportTypeDateID': const SafeStringConverter().toJson(
    instance.reportTypeDateId,
  ),
  'reportTypeID': const SafeStringConverter().toJson(instance.reportTypeId),
  'name': const SafeStringConverter().toJson(instance.name),
  'applyCycle': const SafeStringConverter().toJson(instance.applyCycle),
  'isRequired': const SafeBoolConverter().toJson(instance.isRequired),
  'disableFreeType': const SafeBoolConverter().toJson(instance.disableFreeType),
  'created_at': const SafeDateTimeConverter().toJson(instance.createdAt),
  'updated_at': const SafeDateTimeConverter().toJson(instance.updatedAt),
};

_StatusRuleReport _$StatusRuleReportFromJson(Map<String, dynamic> json) =>
    _StatusRuleReport(
      statusRuleReportId: const SafeStringConverter().fromJson(
        json['statusRuleReportID'],
      ),
      reportTypeId: const SafeStringConverter().fromJson(json['reportTypeID']),
      status: const SafeStringConverter().fromJson(json['status']),
      field: const SafeStringConverter().fromJson(json['field']),
      statusRuleReportOperator: const SafeStringConverter().fromJson(
        json['operator'],
      ),
      value: const SafeStringConverter().fromJson(json['value']),
      createdAt: const SafeDateTimeConverter().fromJson(json['created_at']),
      updatedAt: const SafeDateTimeConverter().fromJson(json['updated_at']),
    );

Map<String, dynamic> _$StatusRuleReportToJson(_StatusRuleReport instance) =>
    <String, dynamic>{
      'statusRuleReportID': const SafeStringConverter().toJson(
        instance.statusRuleReportId,
      ),
      'reportTypeID': const SafeStringConverter().toJson(instance.reportTypeId),
      'status': const SafeStringConverter().toJson(instance.status),
      'field': const SafeStringConverter().toJson(instance.field),
      'operator': const SafeStringConverter().toJson(
        instance.statusRuleReportOperator,
      ),
      'value': const SafeStringConverter().toJson(instance.value),
      'created_at': const SafeDateTimeConverter().toJson(instance.createdAt),
      'updated_at': const SafeDateTimeConverter().toJson(instance.updatedAt),
    };
