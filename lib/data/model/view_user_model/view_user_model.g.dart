// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ViewUserModel _$ViewUserModelFromJson(Map<String, dynamic> json) =>
    _ViewUserModel(
      count: (json['count'] as num).toInt(),
      message: json['message'] as String,
      users: (json['users'] as List<dynamic>)
          .map((e) => AuthUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ViewUserModelToJson(_ViewUserModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'message': instance.message,
      'users': instance.users,
    };

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  username: json['username'] as String,
  divisionId: json['divisionid'] as String,
  code: json['code'] as String,
  passwordReset: json['password_reset'] as bool,
  isAccountLocked: json['is_account_locked'] as bool,
  userGroup: json['user_group'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'divisionid': instance.divisionId,
  'code': instance.code,
  'password_reset': instance.passwordReset,
  'is_account_locked': instance.isAccountLocked,
  'user_group': instance.userGroup,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
