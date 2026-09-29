// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_site_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetSiteModel _$GetSiteModelFromJson(Map<String, dynamic> json) =>
    _GetSiteModel(
      sites:
          (json['sites'] as List<dynamic>?)
              ?.map((e) => Site.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetSiteModelToJson(_GetSiteModel instance) =>
    <String, dynamic>{
      'sites': instance.sites,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };

_Site _$SiteFromJson(Map<String, dynamic> json) => _Site(
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
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$SiteToJson(_Site instance) => <String, dynamic>{
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
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
