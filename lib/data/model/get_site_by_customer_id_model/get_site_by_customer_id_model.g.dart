// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_site_by_customer_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetSiteByCustomerIdModel _$GetSiteByCustomerIdModelFromJson(
  Map<String, dynamic> json,
) => _GetSiteByCustomerIdModel(
  customerId: json['customer_id'] as String?,
  siteCustomers: (json['sites'] as List<dynamic>?)
      ?.map((e) => SiteCustomer.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetSiteByCustomerIdModelToJson(
  _GetSiteByCustomerIdModel instance,
) => <String, dynamic>{
  'customer_id': instance.customerId,
  'sites': instance.siteCustomers,
  'total': instance.total,
};

_SiteCustomer _$SiteCustomerFromJson(Map<String, dynamic> json) =>
    _SiteCustomer(
      siteid: json['siteid'] as String?,
      siteCode: json['sitecode'] as String?,
      customerId: json['customerid'] as String?,
      siteName: json['sitename'] as String?,
      area: json['area'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      divisionId: json['divisionid'] as String?,
      divisionName: json['divisionname'] as String?,
      logo: json['logo'] as String?,
      address: json['address'] as String?,
      archived: json['archived'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SiteCustomerToJson(_SiteCustomer instance) =>
    <String, dynamic>{
      'siteid': instance.siteid,
      'sitecode': instance.siteCode,
      'customerid': instance.customerId,
      'sitename': instance.siteName,
      'area': instance.area,
      'description': instance.description,
      'notes': instance.notes,
      'divisionid': instance.divisionId,
      'divisionname': instance.divisionName,
      'logo': instance.logo,
      'address': instance.address,
      'archived': instance.archived,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
