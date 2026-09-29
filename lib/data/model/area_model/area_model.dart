import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_model.freezed.dart';
part 'area_model.g.dart';

@freezed
abstract class AreaModel with _$AreaModel {
  const AreaModel._();

  const factory AreaModel({
    String? areaid,
    String? personnelid,
    String? areaname,
    String? areacode,
  }) = _AreaModel;

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);

  String get displayName => areaname ?? areacode ?? '';
}

@freezed
abstract class GetAreaModel with _$GetAreaModel {
  const factory GetAreaModel({
    @Default([]) List<AreaModel> areas,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
    @Default(1) int totalPages,
  }) = _GetAreaModel;

  factory GetAreaModel.fromJson(Map<String, dynamic> json) =>
      _$GetAreaModelFromJson(json);
}