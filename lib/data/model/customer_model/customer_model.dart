import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';

@freezed
abstract class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String name,
    required String accountCode,
    required String division,
    required String status,
  }) = _CustomerModel;
}