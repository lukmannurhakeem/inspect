// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonnelModel _$PersonnelModelFromJson(Map<String, dynamic> json) =>
    _PersonnelModel(
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => PersonnelData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonnelModelToJson(_PersonnelModel instance) =>
    <String, dynamic>{'count': instance.count, 'data': instance.data};

_PersonnelData _$PersonnelDataFromJson(Map<String, dynamic> json) =>
    _PersonnelData(
      personnel: Personnel.fromJson(json['personnel'] as Map<String, dynamic>),
      contactInfo: ContactInfo.fromJson(
        json['contactInfo'] as Map<String, dynamic>,
      ),
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      availability: (json['availability'] as List<dynamic>)
          .map((e) => Availability.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualification: Qualification.fromJson(
        json['qualification'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PersonnelDataToJson(_PersonnelData instance) =>
    <String, dynamic>{
      'personnel': instance.personnel,
      'contactInfo': instance.contactInfo,
      'company': instance.company,
      'availability': instance.availability,
      'qualification': instance.qualification,
    };

_Personnel _$PersonnelFromJson(Map<String, dynamic> json) => _Personnel(
  personnelID: json['personnelID'] as String,
  divisionID: json['divisionID'] as String,
  divisionName: json['divisionName'] as String,
  title: json['title'] as String,
  firstName: json['firstName'] as String,
  middleName: json['middleName'] as String,
  lastName: json['lastName'] as String,
  signatureFile: json['signatureFile'] as String,
  isArchived: json['isArchived'] as bool,
  isHiddenFromPlanner: json['isHiddenFromPlanner'] as bool,
  miscNotes: json['miscNotes'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PersonnelToJson(_Personnel instance) =>
    <String, dynamic>{
      'personnelID': instance.personnelID,
      'divisionID': instance.divisionID,
      'divisionName': instance.divisionName,
      'title': instance.title,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'signatureFile': instance.signatureFile,
      'isArchived': instance.isArchived,
      'isHiddenFromPlanner': instance.isHiddenFromPlanner,
      'miscNotes': instance.miscNotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => _ContactInfo(
  contactID: json['contactID'] as String,
  personnelID: json['personnelID'] as String,
  workAddress: json['workAddress'] as String,
  workMobilePhone: json['workMobilePhone'] as String,
  workPhone: json['workPhone'] as String,
  workEmail: json['workEmail'] as String,
  workSecondaryEmail: json['workSecondaryEmail'] as String,
  homeAddress: json['homeAddress'] as String,
  homePhone: json['homePhone'] as String,
  personalEmail: json['personalEmail'] as String,
  personalSecondaryEmail: json['personalSecondaryEmail'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ContactInfoToJson(_ContactInfo instance) =>
    <String, dynamic>{
      'contactID': instance.contactID,
      'personnelID': instance.personnelID,
      'workAddress': instance.workAddress,
      'workMobilePhone': instance.workMobilePhone,
      'workPhone': instance.workPhone,
      'workEmail': instance.workEmail,
      'workSecondaryEmail': instance.workSecondaryEmail,
      'homeAddress': instance.homeAddress,
      'homePhone': instance.homePhone,
      'personalEmail': instance.personalEmail,
      'personalSecondaryEmail': instance.personalSecondaryEmail,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_Company _$CompanyFromJson(Map<String, dynamic> json) => _Company(
  companyID: json['companyID'] as String,
  personnelID: json['personnelID'] as String,
  associatedLogin: json['associatedLogin'] as String,
  employeeNumber: json['employeeNumber'] as String,
  jobTitle: json['jobTitle'] as String,
  generalNotes: json['generalNotes'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CompanyToJson(_Company instance) => <String, dynamic>{
  'companyID': instance.companyID,
  'personnelID': instance.personnelID,
  'associatedLogin': instance.associatedLogin,
  'employeeNumber': instance.employeeNumber,
  'jobTitle': instance.jobTitle,
  'generalNotes': instance.generalNotes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_Availability _$AvailabilityFromJson(Map<String, dynamic> json) =>
    _Availability(
      availabilityID: json['availabilityID'] as String,
      personnelID: json['personnelID'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AvailabilityToJson(_Availability instance) =>
    <String, dynamic>{
      'availabilityID': instance.availabilityID,
      'personnelID': instance.personnelID,
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_Qualification _$QualificationFromJson(Map<String, dynamic> json) =>
    _Qualification(
      qualificationID: json['qualificationID'] as String,
      personnelID: json['personnelID'] as String,
      iratCert: json['iratCert'] as String,
      eddyQualification: json['eddyQualification'] as String,
      magneticQualification: json['magneticQualification'] as String,
      liquidQualification: json['liquidQualification'] as String,
      ultrasonicQualification: json['ultrasonicQualification'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$QualificationToJson(_Qualification instance) =>
    <String, dynamic>{
      'qualificationID': instance.qualificationID,
      'personnelID': instance.personnelID,
      'iratCert': instance.iratCert,
      'eddyQualification': instance.eddyQualification,
      'magneticQualification': instance.magneticQualification,
      'liquidQualification': instance.liquidQualification,
      'ultrasonicQualification': instance.ultrasonicQualification,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
