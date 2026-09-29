import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_location_item_model.freezed.dart';
part 'job_location_item_model.g.dart';

@freezed
abstract class JobLocationItemModel with _$JobLocationItemModel {
  const factory JobLocationItemModel({
    int? count,
    List<JobLocationItem>? items,
  }) = _JobLocationItemModel;

  factory JobLocationItemModel.fromJson(Map<String, dynamic> json) =>
      _$JobLocationItemModelFromJson(json);
}

@freezed
abstract class JobLocationItem with _$JobLocationItem {
  const factory JobLocationItem({
    @JsonKey(name: 'locationID') String? locationId,
    @JsonKey(name: 'itemID') String? itemId,
    String? name,
    String? code,
    @JsonKey(name: 'parentID') String? parentId,
  }) = _JobLocationItem;

  factory JobLocationItem.fromJson(Map<String, dynamic> json) =>
      _$JobLocationItemFromJson(json);
}
