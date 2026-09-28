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