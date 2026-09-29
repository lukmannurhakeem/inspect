
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_customer_model.freezed.dart';
part 'get_customer_model.g.dart';

@freezed
abstract class GetCustomerModel with _$GetCustomerModel {
const factory GetCustomerModel({
@Default([]) List<Customer> customers,
int? total,
int? page,
int? limit,
int? totalPages,
}) = _GetCustomerModel;

factory GetCustomerModel.fromJson(Map<String, dynamic> json) =>
_$GetCustomerModelFromJson(json);
}

@freezed
abstract class Customer with _$Customer {
const factory Customer({
String? customerid,
String? customername,
String? sitecode,
@JsonKey(name: 'account_code') String? accountCode,
String? agent,
@JsonKey(name: 'agent_name') String? agentName,
String? notes,
String? logo,
String? address,
bool? archived,
String? divisionid,
String? divisionname,
@JsonKey(name: 'created_at') DateTime? createdAt,
@JsonKey(name: 'updated_at') DateTime? updatedAt,
}) = _Customer;

factory Customer.fromJson(Map<String, dynamic> json) =>
_$CustomerFromJson(json);
}