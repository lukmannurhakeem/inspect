
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_site_by_customer_id_model.freezed.dart';
part 'get_site_by_customer_id_model.g.dart';

@freezed
abstract class GetSiteByCustomerIdModel with _$GetSiteByCustomerIdModel {
const factory GetSiteByCustomerIdModel({
@JsonKey(name: 'customer_id') String? customerId,
@JsonKey(name: 'sites') List<SiteCustomer>? siteCustomers,
int? total,
}) = _GetSiteByCustomerIdModel;

factory GetSiteByCustomerIdModel.fromJson(Map<String, dynamic> json) =>
_$GetSiteByCustomerIdModelFromJson(json);
}

@freezed
abstract class SiteCustomer with _$SiteCustomer {
const factory SiteCustomer({
String? siteid,
@JsonKey(name: 'sitecode') String? siteCode,
@JsonKey(name: 'customerid') String? customerId,
@JsonKey(name: 'sitename') String? siteName,
String? area,
String? description,
String? notes,
@JsonKey(name: 'divisionid') String? divisionId,
@JsonKey(name: 'divisionname') String? divisionName,
String? logo,
String? address,
bool? archived,
@JsonKey(name: 'created_at') DateTime? createdAt,
@JsonKey(name: 'updated_at') DateTime? updatedAt,
}) = _SiteCustomer;

factory SiteCustomer.fromJson(Map<String, dynamic> json) =>
_$SiteCustomerFromJson(json);
}
