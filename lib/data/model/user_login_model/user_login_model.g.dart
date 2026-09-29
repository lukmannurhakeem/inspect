// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLoginModel _$UserLoginModelFromJson(Map<String, dynamic> json) =>
    _UserLoginModel(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      expiresIn: (json['expires_in'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserLoginModelToJson(_UserLoginModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
      'expires_in': instance.expiresIn,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  username: json['username'] as String?,
  divisionid: json['divisionid'] as String?,
  code: json['code'] as String?,
  passwordReset: json['password_reset'] as bool?,
  isAccountLocked: json['is_account_locked'] as bool?,
  userGroup: json['user_group'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'divisionid': instance.divisionid,
  'code': instance.code,
  'password_reset': instance.passwordReset,
  'is_account_locked': instance.isAccountLocked,
  'user_group': instance.userGroup,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
