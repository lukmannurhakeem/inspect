import 'package:freezed_annotation/freezed_annotation.dart';

part 'personnel_model.freezed.dart';
part 'personnel_model.g.dart';

@freezed
abstract class PersonnelModel with _$PersonnelModel {
  const factory PersonnelModel({
    required int count,
    required List<PersonnelData> data,
  }) = _PersonnelModel;

  factory PersonnelModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelModelFromJson(json);
}

@freezed
abstract class PersonnelData with _$PersonnelData {
  const PersonnelData._();

  const factory PersonnelData({
    required Personnel personnel,
    required ContactInfo contactInfo,
    required Company company,
    required List<Availability> availability,
    required Qualification qualification,
  }) = _PersonnelData;

  factory PersonnelData.fromJson(Map<String, dynamic> json) =>
      _$PersonnelDataFromJson(json);

  String get fullName => [
    personnel.title,
    personnel.firstName,
    personnel.middleName,
    personnel.lastName,
  ].where((part) => part.isNotEmpty).join(' ');

  String get displayName => [
    personnel.firstName,
    personnel.middleName,
    personnel.lastName,
  ].where((part) => part.isNotEmpty).join(' ');
}

@freezed
abstract class Personnel with _$Personnel {
  const factory Personnel({
    @JsonKey(name: 'personnelID') required String personnelID,
    @JsonKey(name: 'divisionID') required String divisionID,
    required String divisionName,
    required String title,
    required String firstName,
    required String middleName,
    required String lastName,
    required String signatureFile,
    required bool isArchived,
    required bool isHiddenFromPlanner,
    required String miscNotes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Personnel;

  factory Personnel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelFromJson(json);
}

@freezed
abstract class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    @JsonKey(name: 'contactID') required String contactID,
    @JsonKey(name: 'personnelID') required String personnelID,
    required String workAddress,
    required String workMobilePhone,
    required String workPhone,
    required String workEmail,
    required String workSecondaryEmail,
    required String homeAddress,
    required String homePhone,
    required String personalEmail,
    required String personalSecondaryEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}

@freezed
abstract class Company with _$Company {
  const factory Company({
    @JsonKey(name: 'companyID') required String companyID,
    @JsonKey(name: 'personnelID') required String personnelID,
    required String associatedLogin,
    required String employeeNumber,
    required String jobTitle,
    required String generalNotes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}

@freezed
abstract class Availability with _$Availability {
  const Availability._();

  const factory Availability({
    @JsonKey(name: 'availabilityID') required String availabilityID,
    @JsonKey(name: 'personnelID') required String personnelID,
    required String dayOfWeek,
    required DateTime startTime,
    required DateTime endTime,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Availability;

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);

  String get timeRange {
    final start =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    final end =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    return '$start - $end';
  }
}

@freezed
abstract class Qualification with _$Qualification {
  const factory Qualification({
    @JsonKey(name: 'qualificationID') required String qualificationID,
    @JsonKey(name: 'personnelID') required String personnelID,
    required String iratCert,
    required String eddyQualification,
    required String magneticQualification,
    required String liquidQualification,
    required String ultrasonicQualification,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Qualification;

  factory Qualification.fromJson(Map<String, dynamic> json) =>
      _$QualificationFromJson(json);
}