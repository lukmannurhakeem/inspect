
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_refresh_token_model.freezed.dart';
part 'user_refresh_token_model.g.dart';

@freezed
abstract class UserRefreshTokenModel with _$UserRefreshTokenModel {
const factory UserRefreshTokenModel({
@JsonKey(name: 'access_token') String? accessToken,
@JsonKey(name: 'refresh_token') String? refreshToken,
User? user,
@JsonKey(name: 'expires_in') int? expiresIn,
}) = _UserRefreshTokenModel;

factory UserRefreshTokenModel.fromJson(Map<String, dynamic> json) =>
_$UserRefreshTokenModelFromJson(json);
}

@freezed
abstract class User with _$User {
const factory User({
int? id,
String? email,
@JsonKey(name: 'first_name') String? firstName,
@JsonKey(name: 'last_name') String? lastName,
@JsonKey(name: 'created_at') DateTime? createdAt,
@JsonKey(name: 'updated_at') DateTime? updatedAt,
}) = _User;

factory User.fromJson(Map<String, dynamic> json) =>
_$UserFromJson(json);
}

