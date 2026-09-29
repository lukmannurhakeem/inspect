
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_login_model.freezed.dart';
part 'user_login_model.g.dart';

@freezed
abstract class UserLoginModel with _$UserLoginModel {
const factory UserLoginModel({
@JsonKey(name: 'access_token') String? accessToken,
@JsonKey(name: 'refresh_token') String? refreshToken,
User? user,
@JsonKey(name: 'expires_in') int? expiresIn,
}) = _UserLoginModel;

factory UserLoginModel.fromJson(Map<String, dynamic> json) =>
_$UserLoginModelFromJson(json);
}

@freezed
abstract class User with _$User {
const factory User({
int? id,
String? email,
String? username,
String? divisionid,
String? code,
@JsonKey(name: 'password_reset') bool? passwordReset,
@JsonKey(name: 'is_account_locked') bool? isAccountLocked,
@JsonKey(name: 'user_group') String? userGroup,
@JsonKey(name: 'first_name') String? firstName,
@JsonKey(name: 'last_name') String? lastName,
@JsonKey(name: 'created_at') DateTime? createdAt,
@JsonKey(name: 'updated_at') DateTime? updatedAt,
}) = _User;

factory User.fromJson(Map<String, dynamic> json) =>
_$UserFromJson(json);
}

