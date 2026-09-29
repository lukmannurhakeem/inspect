
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_verify_token_model.freezed.dart';
part 'user_verify_token_model.g.dart';

@freezed
abstract class UserVerifyTokenModel with _$UserVerifyTokenModel {
const factory UserVerifyTokenModel({
@JsonKey(name: 'expires_at') DateTime? expiresAt,
@JsonKey(name: 'expires_in_seconds') int? expiresInSeconds,
@JsonKey(name: 'issued_at') DateTime? issuedAt,
@JsonKey(name: 'user_id') int? userId,
bool? valid,
}) = _UserVerifyTokenModel;

factory UserVerifyTokenModel.fromJson(Map<String, dynamic> json) =>
_$UserVerifyTokenModelFromJson(json);
}

