import 'package:freezed_annotation/freezed_annotation.dart';

part 'regulation_model.freezed.dart';
part 'regulation_model.g.dart';

@freezed
abstract class RegulationModel with _$RegulationModel {
  const factory RegulationModel({
    @JsonKey(name: 'regulationId')
    String? regulationId,
    @JsonKey(name: 'regulationName')
    String? regulationName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RegulationModel;

  factory RegulationModel.fromJson(Map<String, dynamic> json) =>
      _$RegulationModelFromJson(json);
}

List<RegulationModel> regulationListFromJson(
    Map<String, dynamic> json,
    ) {
  final list = json['data'] as List<dynamic>? ??
      json['regulations'] as List<dynamic>? ??
      [];

  return list
      .whereType<Map<String, dynamic>>()
      .map(RegulationModel.fromJson)
      .toList();
}