// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_refresh_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRefreshTokenModel _$UserRefreshTokenModelFromJson(
  Map<String, dynamic> json,
) => _UserRefreshTokenModel(
  accessToken: json['access_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  expiresIn: (json['expires_in'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserRefreshTokenModelToJson(
  _UserRefreshTokenModel instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'user': instance.user,
  'expires_in': instance.expiresIn,
};

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
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
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
