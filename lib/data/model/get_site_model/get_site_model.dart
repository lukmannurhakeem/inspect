import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_site_model.freezed.dart';
part 'get_site_model.g.dart';

@freezed
abstract class GetSiteModel with _$GetSiteModel {
  const factory GetSiteModel({
    @Default([]) List<Site> sites,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) = _GetSiteModel;

  factory GetSiteModel.fromJson(Map<String, dynamic> json) =>
      _$GetSiteModelFromJson(json);
}

@freezed
abstract class Site with _$Site {
  const factory Site({
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
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Site;

  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);
}
