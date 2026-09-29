import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_register_model.freezed.dart';
part 'job_register_model.g.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    @JsonKey(name: 'itemId') String? itemId,
    String? itemNo,
    String? description,
    bool? archived,
    String? rfidNo,
    @JsonKey(name: 'categoryId') String? categoryId,
    @JsonKey(name: 'locationId') String? locationId,
    String? detailedLocation,
    String? internalNotes,
    String? manufacturer,
    String? manufacturerAddress,
    DateTime? manufacturerDate,
    DateTime? firstUseDate,
    DateTime? expiryDateTimeStamp,
    String? status,
    String? swl,
    String? photoReference,
    String? standardReference,
    Map<String, dynamic>? customFields,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) =>
      _$ItemFromJson(json);
}

@freezed
abstract class JobRegisterModel with _$JobRegisterModel {
  const factory JobRegisterModel({
    List<Item>? items,
    String? jobId,
    String? jobName,
  }) = _JobRegisterModel;

  factory JobRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$JobRegisterModelFromJson(json);
}
