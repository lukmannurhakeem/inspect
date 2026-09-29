
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_company_division.freezed.dart';
part 'get_company_division.g.dart';

@freezed
abstract class GetCompanyDivision with _$GetCompanyDivision {
const factory GetCompanyDivision({
String? divisionid,
String? customerid,
String? divisionname,
String? divisioncode,
String? logo,
String? address,
String? telephone,
String? website,
String? email,
String? fax,
String? culture,
String? timezone,
}) = _GetCompanyDivision;

factory GetCompanyDivision.fromJson(Map<String, dynamic> json) =>
_$GetCompanyDivisionFromJson(json);
}

