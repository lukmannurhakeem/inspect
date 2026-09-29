
import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_user_model.freezed.dart';
part 'view_user_model.g.dart';

@freezed
abstract class ViewUserModel with _$ViewUserModel {
const factory ViewUserModel({
required int count,
required String message,
required List<AuthUser> users,
}) = _ViewUserModel;

factory ViewUserModel.fromJson(Map<String, dynamic> json) =>
_$ViewUserModelFromJson(json);
}

@freezed
abstract class AuthUser with _$AuthUser {
const AuthUser._();

const factory AuthUser({
required int id,
required String email,
required String username,
@JsonKey(name: 'divisionid') required String divisionId,
required String code,
@JsonKey(name: 'password_reset') required bool passwordReset,
@JsonKey(name: 'is_account_locked') required bool isAccountLocked,
@JsonKey(name: 'user_group') required String userGroup,
@JsonKey(name: 'first_name') required String firstName,
@JsonKey(name: 'last_name') required String lastName,
@JsonKey(name: 'created_at') required String createdAt,
@JsonKey(name: 'updated_at') required String updatedAt,
}) = _AuthUser;

factory AuthUser.fromJson(Map<String, dynamic> json) =>
_$AuthUserFromJson(json);

String get displayName => '$firstName $lastName'.trim();
}

