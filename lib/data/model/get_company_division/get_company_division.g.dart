// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_company_division.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetCompanyDivision _$GetCompanyDivisionFromJson(Map<String, dynamic> json) =>
    _GetCompanyDivision(
      divisionid: json['divisionid'] as String?,
      customerid: json['customerid'] as String?,
      divisionname: json['divisionname'] as String?,
      divisioncode: json['divisioncode'] as String?,
      logo: json['logo'] as String?,
      address: json['address'] as String?,
      telephone: json['telephone'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      fax: json['fax'] as String?,
      culture: json['culture'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$GetCompanyDivisionToJson(_GetCompanyDivision instance) =>
    <String, dynamic>{
      'divisionid': instance.divisionid,
      'customerid': instance.customerid,
      'divisionname': instance.divisionname,
      'divisioncode': instance.divisioncode,
      'logo': instance.logo,
      'address': instance.address,
      'telephone': instance.telephone,
      'website': instance.website,
      'email': instance.email,
      'fax': instance.fax,
      'culture': instance.culture,
      'timezone': instance.timezone,
    };
