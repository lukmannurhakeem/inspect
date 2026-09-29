// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_verify_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserVerifyTokenModel _$UserVerifyTokenModelFromJson(
  Map<String, dynamic> json,
) => _UserVerifyTokenModel(
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  expiresInSeconds: (json['expires_in_seconds'] as num?)?.toInt(),
  issuedAt: json['issued_at'] == null
      ? null
      : DateTime.parse(json['issued_at'] as String),
  userId: (json['user_id'] as num?)?.toInt(),
  valid: json['valid'] as bool?,
);

Map<String, dynamic> _$UserVerifyTokenModelToJson(
  _UserVerifyTokenModel instance,
) => <String, dynamic>{
  'expires_at': instance.expiresAt?.toIso8601String(),
  'expires_in_seconds': instance.expiresInSeconds,
  'issued_at': instance.issuedAt?.toIso8601String(),
  'user_id': instance.userId,
  'valid': instance.valid,
};
