// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetCustomerModel _$GetCustomerModelFromJson(Map<String, dynamic> json) =>
    _GetCustomerModel(
      customers:
          (json['customers'] as List<dynamic>?)
              ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetCustomerModelToJson(_GetCustomerModel instance) =>
    <String, dynamic>{
      'customers': instance.customers,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  customerid: json['customerid'] as String?,
  customername: json['customername'] as String?,
  sitecode: json['sitecode'] as String?,
  accountCode: json['account_code'] as String?,
  agent: json['agent'] as String?,
  agentName: json['agent_name'] as String?,
  notes: json['notes'] as String?,
  logo: json['logo'] as String?,
  address: json['address'] as String?,
  archived: json['archived'] as bool?,
  divisionid: json['divisionid'] as String?,
  divisionname: json['divisionname'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'customerid': instance.customerid,
  'customername': instance.customername,
  'sitecode': instance.sitecode,
  'account_code': instance.accountCode,
  'agent': instance.agent,
  'agent_name': instance.agentName,
  'notes': instance.notes,
  'logo': instance.logo,
  'address': instance.address,
  'archived': instance.archived,
  'divisionid': instance.divisionid,
  'divisionname': instance.divisionname,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
