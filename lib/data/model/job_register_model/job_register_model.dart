import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_register_model.freezed.dart';
part 'job_register_model.g.dart';

Object? _readId(Map map, String key) => map['itemId'] ?? map['itemID'];

Object? _readCategoryId(Map map, String key) =>
    map['categoryId'] ?? map['categoryID'];

Object? _readLocationId(Map map, String key) =>
    map['locationId'] ?? map['locationID'];

@freezed
abstract class Item with _$Item {
  const factory Item({
    @JsonKey(name: 'itemId', readValue: _readId) String? itemId,
    String? itemNo,
    String? description,
    bool? archived,
    String? rfidNo,
    @JsonKey(name: 'categoryId', readValue: _readCategoryId) String? categoryId,
    String? categoryName,
    @JsonKey(name: 'locationId', readValue: _readLocationId) String? locationId,
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

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
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