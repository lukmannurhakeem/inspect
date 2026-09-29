// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personnel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonnelModel {

 int get count; List<PersonnelData> get data;
/// Create a copy of PersonnelModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonnelModelCopyWith<PersonnelModel> get copyWith => _$PersonnelModelCopyWithImpl<PersonnelModel>(this as PersonnelModel, _$identity);

  /// Serializes this PersonnelModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonnelModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PersonnelModel(count: $count, data: $data)';
}


}

/// @nodoc
abstract mixin class $PersonnelModelCopyWith<$Res>  {
  factory $PersonnelModelCopyWith(PersonnelModel value, $Res Function(PersonnelModel) _then) = _$PersonnelModelCopyWithImpl;
@useResult
$Res call({
 int count, List<PersonnelData> data
});




}
/// @nodoc
class _$PersonnelModelCopyWithImpl<$Res>
    implements $PersonnelModelCopyWith<$Res> {
  _$PersonnelModelCopyWithImpl(this._self, this._then);

  final PersonnelModel _self;
  final $Res Function(PersonnelModel) _then;

/// Create a copy of PersonnelModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? data = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<PersonnelData>,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonnelModel].
extension PersonnelModelPatterns on PersonnelModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonnelModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonnelModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonnelModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonnelModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonnelModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonnelModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  List<PersonnelData> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonnelModel() when $default != null:
return $default(_that.count,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  List<PersonnelData> data)  $default,) {final _that = this;
switch (_that) {
case _PersonnelModel():
return $default(_that.count,_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  List<PersonnelData> data)?  $default,) {final _that = this;
switch (_that) {
case _PersonnelModel() when $default != null:
return $default(_that.count,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonnelModel implements PersonnelModel {
  const _PersonnelModel({required this.count, required final  List<PersonnelData> data}): _data = data;
  factory _PersonnelModel.fromJson(Map<String, dynamic> json) => _$PersonnelModelFromJson(json);

@override final  int count;
 final  List<PersonnelData> _data;
@override List<PersonnelData> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of PersonnelModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonnelModelCopyWith<_PersonnelModel> get copyWith => __$PersonnelModelCopyWithImpl<_PersonnelModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonnelModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonnelModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'PersonnelModel(count: $count, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PersonnelModelCopyWith<$Res> implements $PersonnelModelCopyWith<$Res> {
  factory _$PersonnelModelCopyWith(_PersonnelModel value, $Res Function(_PersonnelModel) _then) = __$PersonnelModelCopyWithImpl;
@override @useResult
$Res call({
 int count, List<PersonnelData> data
});




}
/// @nodoc
class __$PersonnelModelCopyWithImpl<$Res>
    implements _$PersonnelModelCopyWith<$Res> {
  __$PersonnelModelCopyWithImpl(this._self, this._then);

  final _PersonnelModel _self;
  final $Res Function(_PersonnelModel) _then;

/// Create a copy of PersonnelModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? data = null,}) {
  return _then(_PersonnelModel(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<PersonnelData>,
  ));
}


}


/// @nodoc
mixin _$PersonnelData {

 Personnel get personnel; ContactInfo get contactInfo; Company get company; List<Availability> get availability; Qualification get qualification;
/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonnelDataCopyWith<PersonnelData> get copyWith => _$PersonnelDataCopyWithImpl<PersonnelData>(this as PersonnelData, _$identity);

  /// Serializes this PersonnelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonnelData&&(identical(other.personnel, personnel) || other.personnel == personnel)&&(identical(other.contactInfo, contactInfo) || other.contactInfo == contactInfo)&&(identical(other.company, company) || other.company == company)&&const DeepCollectionEquality().equals(other.availability, availability)&&(identical(other.qualification, qualification) || other.qualification == qualification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personnel,contactInfo,company,const DeepCollectionEquality().hash(availability),qualification);

@override
String toString() {
  return 'PersonnelData(personnel: $personnel, contactInfo: $contactInfo, company: $company, availability: $availability, qualification: $qualification)';
}


}

/// @nodoc
abstract mixin class $PersonnelDataCopyWith<$Res>  {
  factory $PersonnelDataCopyWith(PersonnelData value, $Res Function(PersonnelData) _then) = _$PersonnelDataCopyWithImpl;
@useResult
$Res call({
 Personnel personnel, ContactInfo contactInfo, Company company, List<Availability> availability, Qualification qualification
});


$PersonnelCopyWith<$Res> get personnel;$ContactInfoCopyWith<$Res> get contactInfo;$CompanyCopyWith<$Res> get company;$QualificationCopyWith<$Res> get qualification;

}
/// @nodoc
class _$PersonnelDataCopyWithImpl<$Res>
    implements $PersonnelDataCopyWith<$Res> {
  _$PersonnelDataCopyWithImpl(this._self, this._then);

  final PersonnelData _self;
  final $Res Function(PersonnelData) _then;

/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personnel = null,Object? contactInfo = null,Object? company = null,Object? availability = null,Object? qualification = null,}) {
  return _then(_self.copyWith(
personnel: null == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as Personnel,contactInfo: null == contactInfo ? _self.contactInfo : contactInfo // ignore: cast_nullable_to_non_nullable
as ContactInfo,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as Company,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as List<Availability>,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as Qualification,
  ));
}
/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonnelCopyWith<$Res> get personnel {
  
  return $PersonnelCopyWith<$Res>(_self.personnel, (value) {
    return _then(_self.copyWith(personnel: value));
  });
}/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactInfoCopyWith<$Res> get contactInfo {
  
  return $ContactInfoCopyWith<$Res>(_self.contactInfo, (value) {
    return _then(_self.copyWith(contactInfo: value));
  });
}/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyCopyWith<$Res> get company {
  
  return $CompanyCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QualificationCopyWith<$Res> get qualification {
  
  return $QualificationCopyWith<$Res>(_self.qualification, (value) {
    return _then(_self.copyWith(qualification: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonnelData].
extension PersonnelDataPatterns on PersonnelData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonnelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonnelData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonnelData value)  $default,){
final _that = this;
switch (_that) {
case _PersonnelData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonnelData value)?  $default,){
final _that = this;
switch (_that) {
case _PersonnelData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Personnel personnel,  ContactInfo contactInfo,  Company company,  List<Availability> availability,  Qualification qualification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonnelData() when $default != null:
return $default(_that.personnel,_that.contactInfo,_that.company,_that.availability,_that.qualification);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Personnel personnel,  ContactInfo contactInfo,  Company company,  List<Availability> availability,  Qualification qualification)  $default,) {final _that = this;
switch (_that) {
case _PersonnelData():
return $default(_that.personnel,_that.contactInfo,_that.company,_that.availability,_that.qualification);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Personnel personnel,  ContactInfo contactInfo,  Company company,  List<Availability> availability,  Qualification qualification)?  $default,) {final _that = this;
switch (_that) {
case _PersonnelData() when $default != null:
return $default(_that.personnel,_that.contactInfo,_that.company,_that.availability,_that.qualification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonnelData extends PersonnelData {
  const _PersonnelData({required this.personnel, required this.contactInfo, required this.company, required final  List<Availability> availability, required this.qualification}): _availability = availability,super._();
  factory _PersonnelData.fromJson(Map<String, dynamic> json) => _$PersonnelDataFromJson(json);

@override final  Personnel personnel;
@override final  ContactInfo contactInfo;
@override final  Company company;
 final  List<Availability> _availability;
@override List<Availability> get availability {
  if (_availability is EqualUnmodifiableListView) return _availability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availability);
}

@override final  Qualification qualification;

/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonnelDataCopyWith<_PersonnelData> get copyWith => __$PersonnelDataCopyWithImpl<_PersonnelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonnelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonnelData&&(identical(other.personnel, personnel) || other.personnel == personnel)&&(identical(other.contactInfo, contactInfo) || other.contactInfo == contactInfo)&&(identical(other.company, company) || other.company == company)&&const DeepCollectionEquality().equals(other._availability, _availability)&&(identical(other.qualification, qualification) || other.qualification == qualification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personnel,contactInfo,company,const DeepCollectionEquality().hash(_availability),qualification);

@override
String toString() {
  return 'PersonnelData(personnel: $personnel, contactInfo: $contactInfo, company: $company, availability: $availability, qualification: $qualification)';
}


}

/// @nodoc
abstract mixin class _$PersonnelDataCopyWith<$Res> implements $PersonnelDataCopyWith<$Res> {
  factory _$PersonnelDataCopyWith(_PersonnelData value, $Res Function(_PersonnelData) _then) = __$PersonnelDataCopyWithImpl;
@override @useResult
$Res call({
 Personnel personnel, ContactInfo contactInfo, Company company, List<Availability> availability, Qualification qualification
});


@override $PersonnelCopyWith<$Res> get personnel;@override $ContactInfoCopyWith<$Res> get contactInfo;@override $CompanyCopyWith<$Res> get company;@override $QualificationCopyWith<$Res> get qualification;

}
/// @nodoc
class __$PersonnelDataCopyWithImpl<$Res>
    implements _$PersonnelDataCopyWith<$Res> {
  __$PersonnelDataCopyWithImpl(this._self, this._then);

  final _PersonnelData _self;
  final $Res Function(_PersonnelData) _then;

/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personnel = null,Object? contactInfo = null,Object? company = null,Object? availability = null,Object? qualification = null,}) {
  return _then(_PersonnelData(
personnel: null == personnel ? _self.personnel : personnel // ignore: cast_nullable_to_non_nullable
as Personnel,contactInfo: null == contactInfo ? _self.contactInfo : contactInfo // ignore: cast_nullable_to_non_nullable
as ContactInfo,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as Company,availability: null == availability ? _self._availability : availability // ignore: cast_nullable_to_non_nullable
as List<Availability>,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as Qualification,
  ));
}

/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonnelCopyWith<$Res> get personnel {
  
  return $PersonnelCopyWith<$Res>(_self.personnel, (value) {
    return _then(_self.copyWith(personnel: value));
  });
}/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactInfoCopyWith<$Res> get contactInfo {
  
  return $ContactInfoCopyWith<$Res>(_self.contactInfo, (value) {
    return _then(_self.copyWith(contactInfo: value));
  });
}/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyCopyWith<$Res> get company {
  
  return $CompanyCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}/// Create a copy of PersonnelData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QualificationCopyWith<$Res> get qualification {
  
  return $QualificationCopyWith<$Res>(_self.qualification, (value) {
    return _then(_self.copyWith(qualification: value));
  });
}
}


/// @nodoc
mixin _$Personnel {

@JsonKey(name: 'personnelID') String get personnelID;@JsonKey(name: 'divisionID') String get divisionID; String get divisionName; String get title; String get firstName; String get middleName; String get lastName; String get signatureFile; bool get isArchived; bool get isHiddenFromPlanner; String get miscNotes; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Personnel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonnelCopyWith<Personnel> get copyWith => _$PersonnelCopyWithImpl<Personnel>(this as Personnel, _$identity);

  /// Serializes this Personnel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Personnel&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.divisionID, divisionID) || other.divisionID == divisionID)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.title, title) || other.title == title)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.middleName, middleName) || other.middleName == middleName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.signatureFile, signatureFile) || other.signatureFile == signatureFile)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isHiddenFromPlanner, isHiddenFromPlanner) || other.isHiddenFromPlanner == isHiddenFromPlanner)&&(identical(other.miscNotes, miscNotes) || other.miscNotes == miscNotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personnelID,divisionID,divisionName,title,firstName,middleName,lastName,signatureFile,isArchived,isHiddenFromPlanner,miscNotes,createdAt,updatedAt);

@override
String toString() {
  return 'Personnel(personnelID: $personnelID, divisionID: $divisionID, divisionName: $divisionName, title: $title, firstName: $firstName, middleName: $middleName, lastName: $lastName, signatureFile: $signatureFile, isArchived: $isArchived, isHiddenFromPlanner: $isHiddenFromPlanner, miscNotes: $miscNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PersonnelCopyWith<$Res>  {
  factory $PersonnelCopyWith(Personnel value, $Res Function(Personnel) _then) = _$PersonnelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'personnelID') String personnelID,@JsonKey(name: 'divisionID') String divisionID, String divisionName, String title, String firstName, String middleName, String lastName, String signatureFile, bool isArchived, bool isHiddenFromPlanner, String miscNotes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PersonnelCopyWithImpl<$Res>
    implements $PersonnelCopyWith<$Res> {
  _$PersonnelCopyWithImpl(this._self, this._then);

  final Personnel _self;
  final $Res Function(Personnel) _then;

/// Create a copy of Personnel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personnelID = null,Object? divisionID = null,Object? divisionName = null,Object? title = null,Object? firstName = null,Object? middleName = null,Object? lastName = null,Object? signatureFile = null,Object? isArchived = null,Object? isHiddenFromPlanner = null,Object? miscNotes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,divisionID: null == divisionID ? _self.divisionID : divisionID // ignore: cast_nullable_to_non_nullable
as String,divisionName: null == divisionName ? _self.divisionName : divisionName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,middleName: null == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,signatureFile: null == signatureFile ? _self.signatureFile : signatureFile // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isHiddenFromPlanner: null == isHiddenFromPlanner ? _self.isHiddenFromPlanner : isHiddenFromPlanner // ignore: cast_nullable_to_non_nullable
as bool,miscNotes: null == miscNotes ? _self.miscNotes : miscNotes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Personnel].
extension PersonnelPatterns on Personnel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Personnel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Personnel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Personnel value)  $default,){
final _that = this;
switch (_that) {
case _Personnel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Personnel value)?  $default,){
final _that = this;
switch (_that) {
case _Personnel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'personnelID')  String personnelID, @JsonKey(name: 'divisionID')  String divisionID,  String divisionName,  String title,  String firstName,  String middleName,  String lastName,  String signatureFile,  bool isArchived,  bool isHiddenFromPlanner,  String miscNotes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Personnel() when $default != null:
return $default(_that.personnelID,_that.divisionID,_that.divisionName,_that.title,_that.firstName,_that.middleName,_that.lastName,_that.signatureFile,_that.isArchived,_that.isHiddenFromPlanner,_that.miscNotes,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'personnelID')  String personnelID, @JsonKey(name: 'divisionID')  String divisionID,  String divisionName,  String title,  String firstName,  String middleName,  String lastName,  String signatureFile,  bool isArchived,  bool isHiddenFromPlanner,  String miscNotes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Personnel():
return $default(_that.personnelID,_that.divisionID,_that.divisionName,_that.title,_that.firstName,_that.middleName,_that.lastName,_that.signatureFile,_that.isArchived,_that.isHiddenFromPlanner,_that.miscNotes,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'personnelID')  String personnelID, @JsonKey(name: 'divisionID')  String divisionID,  String divisionName,  String title,  String firstName,  String middleName,  String lastName,  String signatureFile,  bool isArchived,  bool isHiddenFromPlanner,  String miscNotes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Personnel() when $default != null:
return $default(_that.personnelID,_that.divisionID,_that.divisionName,_that.title,_that.firstName,_that.middleName,_that.lastName,_that.signatureFile,_that.isArchived,_that.isHiddenFromPlanner,_that.miscNotes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Personnel implements Personnel {
  const _Personnel({@JsonKey(name: 'personnelID') required this.personnelID, @JsonKey(name: 'divisionID') required this.divisionID, required this.divisionName, required this.title, required this.firstName, required this.middleName, required this.lastName, required this.signatureFile, required this.isArchived, required this.isHiddenFromPlanner, required this.miscNotes, required this.createdAt, required this.updatedAt});
  factory _Personnel.fromJson(Map<String, dynamic> json) => _$PersonnelFromJson(json);

@override@JsonKey(name: 'personnelID') final  String personnelID;
@override@JsonKey(name: 'divisionID') final  String divisionID;
@override final  String divisionName;
@override final  String title;
@override final  String firstName;
@override final  String middleName;
@override final  String lastName;
@override final  String signatureFile;
@override final  bool isArchived;
@override final  bool isHiddenFromPlanner;
@override final  String miscNotes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Personnel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonnelCopyWith<_Personnel> get copyWith => __$PersonnelCopyWithImpl<_Personnel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonnelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Personnel&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.divisionID, divisionID) || other.divisionID == divisionID)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.title, title) || other.title == title)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.middleName, middleName) || other.middleName == middleName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.signatureFile, signatureFile) || other.signatureFile == signatureFile)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isHiddenFromPlanner, isHiddenFromPlanner) || other.isHiddenFromPlanner == isHiddenFromPlanner)&&(identical(other.miscNotes, miscNotes) || other.miscNotes == miscNotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personnelID,divisionID,divisionName,title,firstName,middleName,lastName,signatureFile,isArchived,isHiddenFromPlanner,miscNotes,createdAt,updatedAt);

@override
String toString() {
  return 'Personnel(personnelID: $personnelID, divisionID: $divisionID, divisionName: $divisionName, title: $title, firstName: $firstName, middleName: $middleName, lastName: $lastName, signatureFile: $signatureFile, isArchived: $isArchived, isHiddenFromPlanner: $isHiddenFromPlanner, miscNotes: $miscNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PersonnelCopyWith<$Res> implements $PersonnelCopyWith<$Res> {
  factory _$PersonnelCopyWith(_Personnel value, $Res Function(_Personnel) _then) = __$PersonnelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'personnelID') String personnelID,@JsonKey(name: 'divisionID') String divisionID, String divisionName, String title, String firstName, String middleName, String lastName, String signatureFile, bool isArchived, bool isHiddenFromPlanner, String miscNotes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PersonnelCopyWithImpl<$Res>
    implements _$PersonnelCopyWith<$Res> {
  __$PersonnelCopyWithImpl(this._self, this._then);

  final _Personnel _self;
  final $Res Function(_Personnel) _then;

/// Create a copy of Personnel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personnelID = null,Object? divisionID = null,Object? divisionName = null,Object? title = null,Object? firstName = null,Object? middleName = null,Object? lastName = null,Object? signatureFile = null,Object? isArchived = null,Object? isHiddenFromPlanner = null,Object? miscNotes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Personnel(
personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,divisionID: null == divisionID ? _self.divisionID : divisionID // ignore: cast_nullable_to_non_nullable
as String,divisionName: null == divisionName ? _self.divisionName : divisionName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,middleName: null == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,signatureFile: null == signatureFile ? _self.signatureFile : signatureFile // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isHiddenFromPlanner: null == isHiddenFromPlanner ? _self.isHiddenFromPlanner : isHiddenFromPlanner // ignore: cast_nullable_to_non_nullable
as bool,miscNotes: null == miscNotes ? _self.miscNotes : miscNotes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ContactInfo {

@JsonKey(name: 'contactID') String get contactID;@JsonKey(name: 'personnelID') String get personnelID; String get workAddress; String get workMobilePhone; String get workPhone; String get workEmail; String get workSecondaryEmail; String get homeAddress; String get homePhone; String get personalEmail; String get personalSecondaryEmail; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactInfoCopyWith<ContactInfo> get copyWith => _$ContactInfoCopyWithImpl<ContactInfo>(this as ContactInfo, _$identity);

  /// Serializes this ContactInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactInfo&&(identical(other.contactID, contactID) || other.contactID == contactID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.workAddress, workAddress) || other.workAddress == workAddress)&&(identical(other.workMobilePhone, workMobilePhone) || other.workMobilePhone == workMobilePhone)&&(identical(other.workPhone, workPhone) || other.workPhone == workPhone)&&(identical(other.workEmail, workEmail) || other.workEmail == workEmail)&&(identical(other.workSecondaryEmail, workSecondaryEmail) || other.workSecondaryEmail == workSecondaryEmail)&&(identical(other.homeAddress, homeAddress) || other.homeAddress == homeAddress)&&(identical(other.homePhone, homePhone) || other.homePhone == homePhone)&&(identical(other.personalEmail, personalEmail) || other.personalEmail == personalEmail)&&(identical(other.personalSecondaryEmail, personalSecondaryEmail) || other.personalSecondaryEmail == personalSecondaryEmail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contactID,personnelID,workAddress,workMobilePhone,workPhone,workEmail,workSecondaryEmail,homeAddress,homePhone,personalEmail,personalSecondaryEmail,createdAt,updatedAt);

@override
String toString() {
  return 'ContactInfo(contactID: $contactID, personnelID: $personnelID, workAddress: $workAddress, workMobilePhone: $workMobilePhone, workPhone: $workPhone, workEmail: $workEmail, workSecondaryEmail: $workSecondaryEmail, homeAddress: $homeAddress, homePhone: $homePhone, personalEmail: $personalEmail, personalSecondaryEmail: $personalSecondaryEmail, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ContactInfoCopyWith<$Res>  {
  factory $ContactInfoCopyWith(ContactInfo value, $Res Function(ContactInfo) _then) = _$ContactInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'contactID') String contactID,@JsonKey(name: 'personnelID') String personnelID, String workAddress, String workMobilePhone, String workPhone, String workEmail, String workSecondaryEmail, String homeAddress, String homePhone, String personalEmail, String personalSecondaryEmail, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ContactInfoCopyWithImpl<$Res>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._self, this._then);

  final ContactInfo _self;
  final $Res Function(ContactInfo) _then;

/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contactID = null,Object? personnelID = null,Object? workAddress = null,Object? workMobilePhone = null,Object? workPhone = null,Object? workEmail = null,Object? workSecondaryEmail = null,Object? homeAddress = null,Object? homePhone = null,Object? personalEmail = null,Object? personalSecondaryEmail = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
contactID: null == contactID ? _self.contactID : contactID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,workAddress: null == workAddress ? _self.workAddress : workAddress // ignore: cast_nullable_to_non_nullable
as String,workMobilePhone: null == workMobilePhone ? _self.workMobilePhone : workMobilePhone // ignore: cast_nullable_to_non_nullable
as String,workPhone: null == workPhone ? _self.workPhone : workPhone // ignore: cast_nullable_to_non_nullable
as String,workEmail: null == workEmail ? _self.workEmail : workEmail // ignore: cast_nullable_to_non_nullable
as String,workSecondaryEmail: null == workSecondaryEmail ? _self.workSecondaryEmail : workSecondaryEmail // ignore: cast_nullable_to_non_nullable
as String,homeAddress: null == homeAddress ? _self.homeAddress : homeAddress // ignore: cast_nullable_to_non_nullable
as String,homePhone: null == homePhone ? _self.homePhone : homePhone // ignore: cast_nullable_to_non_nullable
as String,personalEmail: null == personalEmail ? _self.personalEmail : personalEmail // ignore: cast_nullable_to_non_nullable
as String,personalSecondaryEmail: null == personalSecondaryEmail ? _self.personalSecondaryEmail : personalSecondaryEmail // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactInfo].
extension ContactInfoPatterns on ContactInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactInfo value)  $default,){
final _that = this;
switch (_that) {
case _ContactInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'contactID')  String contactID, @JsonKey(name: 'personnelID')  String personnelID,  String workAddress,  String workMobilePhone,  String workPhone,  String workEmail,  String workSecondaryEmail,  String homeAddress,  String homePhone,  String personalEmail,  String personalSecondaryEmail,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that.contactID,_that.personnelID,_that.workAddress,_that.workMobilePhone,_that.workPhone,_that.workEmail,_that.workSecondaryEmail,_that.homeAddress,_that.homePhone,_that.personalEmail,_that.personalSecondaryEmail,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'contactID')  String contactID, @JsonKey(name: 'personnelID')  String personnelID,  String workAddress,  String workMobilePhone,  String workPhone,  String workEmail,  String workSecondaryEmail,  String homeAddress,  String homePhone,  String personalEmail,  String personalSecondaryEmail,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactInfo():
return $default(_that.contactID,_that.personnelID,_that.workAddress,_that.workMobilePhone,_that.workPhone,_that.workEmail,_that.workSecondaryEmail,_that.homeAddress,_that.homePhone,_that.personalEmail,_that.personalSecondaryEmail,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'contactID')  String contactID, @JsonKey(name: 'personnelID')  String personnelID,  String workAddress,  String workMobilePhone,  String workPhone,  String workEmail,  String workSecondaryEmail,  String homeAddress,  String homePhone,  String personalEmail,  String personalSecondaryEmail,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactInfo() when $default != null:
return $default(_that.contactID,_that.personnelID,_that.workAddress,_that.workMobilePhone,_that.workPhone,_that.workEmail,_that.workSecondaryEmail,_that.homeAddress,_that.homePhone,_that.personalEmail,_that.personalSecondaryEmail,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactInfo implements ContactInfo {
  const _ContactInfo({@JsonKey(name: 'contactID') required this.contactID, @JsonKey(name: 'personnelID') required this.personnelID, required this.workAddress, required this.workMobilePhone, required this.workPhone, required this.workEmail, required this.workSecondaryEmail, required this.homeAddress, required this.homePhone, required this.personalEmail, required this.personalSecondaryEmail, required this.createdAt, required this.updatedAt});
  factory _ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);

@override@JsonKey(name: 'contactID') final  String contactID;
@override@JsonKey(name: 'personnelID') final  String personnelID;
@override final  String workAddress;
@override final  String workMobilePhone;
@override final  String workPhone;
@override final  String workEmail;
@override final  String workSecondaryEmail;
@override final  String homeAddress;
@override final  String homePhone;
@override final  String personalEmail;
@override final  String personalSecondaryEmail;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactInfoCopyWith<_ContactInfo> get copyWith => __$ContactInfoCopyWithImpl<_ContactInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactInfo&&(identical(other.contactID, contactID) || other.contactID == contactID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.workAddress, workAddress) || other.workAddress == workAddress)&&(identical(other.workMobilePhone, workMobilePhone) || other.workMobilePhone == workMobilePhone)&&(identical(other.workPhone, workPhone) || other.workPhone == workPhone)&&(identical(other.workEmail, workEmail) || other.workEmail == workEmail)&&(identical(other.workSecondaryEmail, workSecondaryEmail) || other.workSecondaryEmail == workSecondaryEmail)&&(identical(other.homeAddress, homeAddress) || other.homeAddress == homeAddress)&&(identical(other.homePhone, homePhone) || other.homePhone == homePhone)&&(identical(other.personalEmail, personalEmail) || other.personalEmail == personalEmail)&&(identical(other.personalSecondaryEmail, personalSecondaryEmail) || other.personalSecondaryEmail == personalSecondaryEmail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contactID,personnelID,workAddress,workMobilePhone,workPhone,workEmail,workSecondaryEmail,homeAddress,homePhone,personalEmail,personalSecondaryEmail,createdAt,updatedAt);

@override
String toString() {
  return 'ContactInfo(contactID: $contactID, personnelID: $personnelID, workAddress: $workAddress, workMobilePhone: $workMobilePhone, workPhone: $workPhone, workEmail: $workEmail, workSecondaryEmail: $workSecondaryEmail, homeAddress: $homeAddress, homePhone: $homePhone, personalEmail: $personalEmail, personalSecondaryEmail: $personalSecondaryEmail, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactInfoCopyWith<$Res> implements $ContactInfoCopyWith<$Res> {
  factory _$ContactInfoCopyWith(_ContactInfo value, $Res Function(_ContactInfo) _then) = __$ContactInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'contactID') String contactID,@JsonKey(name: 'personnelID') String personnelID, String workAddress, String workMobilePhone, String workPhone, String workEmail, String workSecondaryEmail, String homeAddress, String homePhone, String personalEmail, String personalSecondaryEmail, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ContactInfoCopyWithImpl<$Res>
    implements _$ContactInfoCopyWith<$Res> {
  __$ContactInfoCopyWithImpl(this._self, this._then);

  final _ContactInfo _self;
  final $Res Function(_ContactInfo) _then;

/// Create a copy of ContactInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contactID = null,Object? personnelID = null,Object? workAddress = null,Object? workMobilePhone = null,Object? workPhone = null,Object? workEmail = null,Object? workSecondaryEmail = null,Object? homeAddress = null,Object? homePhone = null,Object? personalEmail = null,Object? personalSecondaryEmail = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ContactInfo(
contactID: null == contactID ? _self.contactID : contactID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,workAddress: null == workAddress ? _self.workAddress : workAddress // ignore: cast_nullable_to_non_nullable
as String,workMobilePhone: null == workMobilePhone ? _self.workMobilePhone : workMobilePhone // ignore: cast_nullable_to_non_nullable
as String,workPhone: null == workPhone ? _self.workPhone : workPhone // ignore: cast_nullable_to_non_nullable
as String,workEmail: null == workEmail ? _self.workEmail : workEmail // ignore: cast_nullable_to_non_nullable
as String,workSecondaryEmail: null == workSecondaryEmail ? _self.workSecondaryEmail : workSecondaryEmail // ignore: cast_nullable_to_non_nullable
as String,homeAddress: null == homeAddress ? _self.homeAddress : homeAddress // ignore: cast_nullable_to_non_nullable
as String,homePhone: null == homePhone ? _self.homePhone : homePhone // ignore: cast_nullable_to_non_nullable
as String,personalEmail: null == personalEmail ? _self.personalEmail : personalEmail // ignore: cast_nullable_to_non_nullable
as String,personalSecondaryEmail: null == personalSecondaryEmail ? _self.personalSecondaryEmail : personalSecondaryEmail // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Company {

@JsonKey(name: 'companyID') String get companyID;@JsonKey(name: 'personnelID') String get personnelID; String get associatedLogin; String get employeeNumber; String get jobTitle; String get generalNotes; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyCopyWith<Company> get copyWith => _$CompanyCopyWithImpl<Company>(this as Company, _$identity);

  /// Serializes this Company to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Company&&(identical(other.companyID, companyID) || other.companyID == companyID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.associatedLogin, associatedLogin) || other.associatedLogin == associatedLogin)&&(identical(other.employeeNumber, employeeNumber) || other.employeeNumber == employeeNumber)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.generalNotes, generalNotes) || other.generalNotes == generalNotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyID,personnelID,associatedLogin,employeeNumber,jobTitle,generalNotes,createdAt,updatedAt);

@override
String toString() {
  return 'Company(companyID: $companyID, personnelID: $personnelID, associatedLogin: $associatedLogin, employeeNumber: $employeeNumber, jobTitle: $jobTitle, generalNotes: $generalNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CompanyCopyWith<$Res>  {
  factory $CompanyCopyWith(Company value, $Res Function(Company) _then) = _$CompanyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'companyID') String companyID,@JsonKey(name: 'personnelID') String personnelID, String associatedLogin, String employeeNumber, String jobTitle, String generalNotes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CompanyCopyWithImpl<$Res>
    implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._self, this._then);

  final Company _self;
  final $Res Function(Company) _then;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyID = null,Object? personnelID = null,Object? associatedLogin = null,Object? employeeNumber = null,Object? jobTitle = null,Object? generalNotes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
companyID: null == companyID ? _self.companyID : companyID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,associatedLogin: null == associatedLogin ? _self.associatedLogin : associatedLogin // ignore: cast_nullable_to_non_nullable
as String,employeeNumber: null == employeeNumber ? _self.employeeNumber : employeeNumber // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,generalNotes: null == generalNotes ? _self.generalNotes : generalNotes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Company].
extension CompanyPatterns on Company {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Company value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Company value)  $default,){
final _that = this;
switch (_that) {
case _Company():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Company value)?  $default,){
final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'companyID')  String companyID, @JsonKey(name: 'personnelID')  String personnelID,  String associatedLogin,  String employeeNumber,  String jobTitle,  String generalNotes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.companyID,_that.personnelID,_that.associatedLogin,_that.employeeNumber,_that.jobTitle,_that.generalNotes,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'companyID')  String companyID, @JsonKey(name: 'personnelID')  String personnelID,  String associatedLogin,  String employeeNumber,  String jobTitle,  String generalNotes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Company():
return $default(_that.companyID,_that.personnelID,_that.associatedLogin,_that.employeeNumber,_that.jobTitle,_that.generalNotes,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'companyID')  String companyID, @JsonKey(name: 'personnelID')  String personnelID,  String associatedLogin,  String employeeNumber,  String jobTitle,  String generalNotes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Company() when $default != null:
return $default(_that.companyID,_that.personnelID,_that.associatedLogin,_that.employeeNumber,_that.jobTitle,_that.generalNotes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Company implements Company {
  const _Company({@JsonKey(name: 'companyID') required this.companyID, @JsonKey(name: 'personnelID') required this.personnelID, required this.associatedLogin, required this.employeeNumber, required this.jobTitle, required this.generalNotes, required this.createdAt, required this.updatedAt});
  factory _Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

@override@JsonKey(name: 'companyID') final  String companyID;
@override@JsonKey(name: 'personnelID') final  String personnelID;
@override final  String associatedLogin;
@override final  String employeeNumber;
@override final  String jobTitle;
@override final  String generalNotes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyCopyWith<_Company> get copyWith => __$CompanyCopyWithImpl<_Company>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Company&&(identical(other.companyID, companyID) || other.companyID == companyID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.associatedLogin, associatedLogin) || other.associatedLogin == associatedLogin)&&(identical(other.employeeNumber, employeeNumber) || other.employeeNumber == employeeNumber)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.generalNotes, generalNotes) || other.generalNotes == generalNotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyID,personnelID,associatedLogin,employeeNumber,jobTitle,generalNotes,createdAt,updatedAt);

@override
String toString() {
  return 'Company(companyID: $companyID, personnelID: $personnelID, associatedLogin: $associatedLogin, employeeNumber: $employeeNumber, jobTitle: $jobTitle, generalNotes: $generalNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CompanyCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$CompanyCopyWith(_Company value, $Res Function(_Company) _then) = __$CompanyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'companyID') String companyID,@JsonKey(name: 'personnelID') String personnelID, String associatedLogin, String employeeNumber, String jobTitle, String generalNotes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CompanyCopyWithImpl<$Res>
    implements _$CompanyCopyWith<$Res> {
  __$CompanyCopyWithImpl(this._self, this._then);

  final _Company _self;
  final $Res Function(_Company) _then;

/// Create a copy of Company
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyID = null,Object? personnelID = null,Object? associatedLogin = null,Object? employeeNumber = null,Object? jobTitle = null,Object? generalNotes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Company(
companyID: null == companyID ? _self.companyID : companyID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,associatedLogin: null == associatedLogin ? _self.associatedLogin : associatedLogin // ignore: cast_nullable_to_non_nullable
as String,employeeNumber: null == employeeNumber ? _self.employeeNumber : employeeNumber // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,generalNotes: null == generalNotes ? _self.generalNotes : generalNotes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Availability {

@JsonKey(name: 'availabilityID') String get availabilityID;@JsonKey(name: 'personnelID') String get personnelID; String get dayOfWeek; DateTime get startTime; DateTime get endTime; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityCopyWith<Availability> get copyWith => _$AvailabilityCopyWithImpl<Availability>(this as Availability, _$identity);

  /// Serializes this Availability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Availability&&(identical(other.availabilityID, availabilityID) || other.availabilityID == availabilityID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,availabilityID,personnelID,dayOfWeek,startTime,endTime,createdAt,updatedAt);

@override
String toString() {
  return 'Availability(availabilityID: $availabilityID, personnelID: $personnelID, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AvailabilityCopyWith<$Res>  {
  factory $AvailabilityCopyWith(Availability value, $Res Function(Availability) _then) = _$AvailabilityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'availabilityID') String availabilityID,@JsonKey(name: 'personnelID') String personnelID, String dayOfWeek, DateTime startTime, DateTime endTime, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AvailabilityCopyWithImpl<$Res>
    implements $AvailabilityCopyWith<$Res> {
  _$AvailabilityCopyWithImpl(this._self, this._then);

  final Availability _self;
  final $Res Function(Availability) _then;

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availabilityID = null,Object? personnelID = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
availabilityID: null == availabilityID ? _self.availabilityID : availabilityID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Availability].
extension AvailabilityPatterns on Availability {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Availability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Availability() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Availability value)  $default,){
final _that = this;
switch (_that) {
case _Availability():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Availability value)?  $default,){
final _that = this;
switch (_that) {
case _Availability() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'availabilityID')  String availabilityID, @JsonKey(name: 'personnelID')  String personnelID,  String dayOfWeek,  DateTime startTime,  DateTime endTime,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Availability() when $default != null:
return $default(_that.availabilityID,_that.personnelID,_that.dayOfWeek,_that.startTime,_that.endTime,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'availabilityID')  String availabilityID, @JsonKey(name: 'personnelID')  String personnelID,  String dayOfWeek,  DateTime startTime,  DateTime endTime,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Availability():
return $default(_that.availabilityID,_that.personnelID,_that.dayOfWeek,_that.startTime,_that.endTime,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'availabilityID')  String availabilityID, @JsonKey(name: 'personnelID')  String personnelID,  String dayOfWeek,  DateTime startTime,  DateTime endTime,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Availability() when $default != null:
return $default(_that.availabilityID,_that.personnelID,_that.dayOfWeek,_that.startTime,_that.endTime,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Availability extends Availability {
  const _Availability({@JsonKey(name: 'availabilityID') required this.availabilityID, @JsonKey(name: 'personnelID') required this.personnelID, required this.dayOfWeek, required this.startTime, required this.endTime, required this.createdAt, required this.updatedAt}): super._();
  factory _Availability.fromJson(Map<String, dynamic> json) => _$AvailabilityFromJson(json);

@override@JsonKey(name: 'availabilityID') final  String availabilityID;
@override@JsonKey(name: 'personnelID') final  String personnelID;
@override final  String dayOfWeek;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityCopyWith<_Availability> get copyWith => __$AvailabilityCopyWithImpl<_Availability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Availability&&(identical(other.availabilityID, availabilityID) || other.availabilityID == availabilityID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,availabilityID,personnelID,dayOfWeek,startTime,endTime,createdAt,updatedAt);

@override
String toString() {
  return 'Availability(availabilityID: $availabilityID, personnelID: $personnelID, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityCopyWith<$Res> implements $AvailabilityCopyWith<$Res> {
  factory _$AvailabilityCopyWith(_Availability value, $Res Function(_Availability) _then) = __$AvailabilityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'availabilityID') String availabilityID,@JsonKey(name: 'personnelID') String personnelID, String dayOfWeek, DateTime startTime, DateTime endTime, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AvailabilityCopyWithImpl<$Res>
    implements _$AvailabilityCopyWith<$Res> {
  __$AvailabilityCopyWithImpl(this._self, this._then);

  final _Availability _self;
  final $Res Function(_Availability) _then;

/// Create a copy of Availability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availabilityID = null,Object? personnelID = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Availability(
availabilityID: null == availabilityID ? _self.availabilityID : availabilityID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Qualification {

@JsonKey(name: 'qualificationID') String get qualificationID;@JsonKey(name: 'personnelID') String get personnelID; String get iratCert; String get eddyQualification; String get magneticQualification; String get liquidQualification; String get ultrasonicQualification; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Qualification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QualificationCopyWith<Qualification> get copyWith => _$QualificationCopyWithImpl<Qualification>(this as Qualification, _$identity);

  /// Serializes this Qualification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Qualification&&(identical(other.qualificationID, qualificationID) || other.qualificationID == qualificationID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.iratCert, iratCert) || other.iratCert == iratCert)&&(identical(other.eddyQualification, eddyQualification) || other.eddyQualification == eddyQualification)&&(identical(other.magneticQualification, magneticQualification) || other.magneticQualification == magneticQualification)&&(identical(other.liquidQualification, liquidQualification) || other.liquidQualification == liquidQualification)&&(identical(other.ultrasonicQualification, ultrasonicQualification) || other.ultrasonicQualification == ultrasonicQualification)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,qualificationID,personnelID,iratCert,eddyQualification,magneticQualification,liquidQualification,ultrasonicQualification,createdAt,updatedAt);

@override
String toString() {
  return 'Qualification(qualificationID: $qualificationID, personnelID: $personnelID, iratCert: $iratCert, eddyQualification: $eddyQualification, magneticQualification: $magneticQualification, liquidQualification: $liquidQualification, ultrasonicQualification: $ultrasonicQualification, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $QualificationCopyWith<$Res>  {
  factory $QualificationCopyWith(Qualification value, $Res Function(Qualification) _then) = _$QualificationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'qualificationID') String qualificationID,@JsonKey(name: 'personnelID') String personnelID, String iratCert, String eddyQualification, String magneticQualification, String liquidQualification, String ultrasonicQualification, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$QualificationCopyWithImpl<$Res>
    implements $QualificationCopyWith<$Res> {
  _$QualificationCopyWithImpl(this._self, this._then);

  final Qualification _self;
  final $Res Function(Qualification) _then;

/// Create a copy of Qualification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qualificationID = null,Object? personnelID = null,Object? iratCert = null,Object? eddyQualification = null,Object? magneticQualification = null,Object? liquidQualification = null,Object? ultrasonicQualification = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
qualificationID: null == qualificationID ? _self.qualificationID : qualificationID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,iratCert: null == iratCert ? _self.iratCert : iratCert // ignore: cast_nullable_to_non_nullable
as String,eddyQualification: null == eddyQualification ? _self.eddyQualification : eddyQualification // ignore: cast_nullable_to_non_nullable
as String,magneticQualification: null == magneticQualification ? _self.magneticQualification : magneticQualification // ignore: cast_nullable_to_non_nullable
as String,liquidQualification: null == liquidQualification ? _self.liquidQualification : liquidQualification // ignore: cast_nullable_to_non_nullable
as String,ultrasonicQualification: null == ultrasonicQualification ? _self.ultrasonicQualification : ultrasonicQualification // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Qualification].
extension QualificationPatterns on Qualification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Qualification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Qualification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Qualification value)  $default,){
final _that = this;
switch (_that) {
case _Qualification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Qualification value)?  $default,){
final _that = this;
switch (_that) {
case _Qualification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'qualificationID')  String qualificationID, @JsonKey(name: 'personnelID')  String personnelID,  String iratCert,  String eddyQualification,  String magneticQualification,  String liquidQualification,  String ultrasonicQualification,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Qualification() when $default != null:
return $default(_that.qualificationID,_that.personnelID,_that.iratCert,_that.eddyQualification,_that.magneticQualification,_that.liquidQualification,_that.ultrasonicQualification,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'qualificationID')  String qualificationID, @JsonKey(name: 'personnelID')  String personnelID,  String iratCert,  String eddyQualification,  String magneticQualification,  String liquidQualification,  String ultrasonicQualification,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Qualification():
return $default(_that.qualificationID,_that.personnelID,_that.iratCert,_that.eddyQualification,_that.magneticQualification,_that.liquidQualification,_that.ultrasonicQualification,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'qualificationID')  String qualificationID, @JsonKey(name: 'personnelID')  String personnelID,  String iratCert,  String eddyQualification,  String magneticQualification,  String liquidQualification,  String ultrasonicQualification,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Qualification() when $default != null:
return $default(_that.qualificationID,_that.personnelID,_that.iratCert,_that.eddyQualification,_that.magneticQualification,_that.liquidQualification,_that.ultrasonicQualification,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Qualification implements Qualification {
  const _Qualification({@JsonKey(name: 'qualificationID') required this.qualificationID, @JsonKey(name: 'personnelID') required this.personnelID, required this.iratCert, required this.eddyQualification, required this.magneticQualification, required this.liquidQualification, required this.ultrasonicQualification, required this.createdAt, required this.updatedAt});
  factory _Qualification.fromJson(Map<String, dynamic> json) => _$QualificationFromJson(json);

@override@JsonKey(name: 'qualificationID') final  String qualificationID;
@override@JsonKey(name: 'personnelID') final  String personnelID;
@override final  String iratCert;
@override final  String eddyQualification;
@override final  String magneticQualification;
@override final  String liquidQualification;
@override final  String ultrasonicQualification;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Qualification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QualificationCopyWith<_Qualification> get copyWith => __$QualificationCopyWithImpl<_Qualification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QualificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Qualification&&(identical(other.qualificationID, qualificationID) || other.qualificationID == qualificationID)&&(identical(other.personnelID, personnelID) || other.personnelID == personnelID)&&(identical(other.iratCert, iratCert) || other.iratCert == iratCert)&&(identical(other.eddyQualification, eddyQualification) || other.eddyQualification == eddyQualification)&&(identical(other.magneticQualification, magneticQualification) || other.magneticQualification == magneticQualification)&&(identical(other.liquidQualification, liquidQualification) || other.liquidQualification == liquidQualification)&&(identical(other.ultrasonicQualification, ultrasonicQualification) || other.ultrasonicQualification == ultrasonicQualification)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,qualificationID,personnelID,iratCert,eddyQualification,magneticQualification,liquidQualification,ultrasonicQualification,createdAt,updatedAt);

@override
String toString() {
  return 'Qualification(qualificationID: $qualificationID, personnelID: $personnelID, iratCert: $iratCert, eddyQualification: $eddyQualification, magneticQualification: $magneticQualification, liquidQualification: $liquidQualification, ultrasonicQualification: $ultrasonicQualification, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QualificationCopyWith<$Res> implements $QualificationCopyWith<$Res> {
  factory _$QualificationCopyWith(_Qualification value, $Res Function(_Qualification) _then) = __$QualificationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'qualificationID') String qualificationID,@JsonKey(name: 'personnelID') String personnelID, String iratCert, String eddyQualification, String magneticQualification, String liquidQualification, String ultrasonicQualification, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$QualificationCopyWithImpl<$Res>
    implements _$QualificationCopyWith<$Res> {
  __$QualificationCopyWithImpl(this._self, this._then);

  final _Qualification _self;
  final $Res Function(_Qualification) _then;

/// Create a copy of Qualification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qualificationID = null,Object? personnelID = null,Object? iratCert = null,Object? eddyQualification = null,Object? magneticQualification = null,Object? liquidQualification = null,Object? ultrasonicQualification = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Qualification(
qualificationID: null == qualificationID ? _self.qualificationID : qualificationID // ignore: cast_nullable_to_non_nullable
as String,personnelID: null == personnelID ? _self.personnelID : personnelID // ignore: cast_nullable_to_non_nullable
as String,iratCert: null == iratCert ? _self.iratCert : iratCert // ignore: cast_nullable_to_non_nullable
as String,eddyQualification: null == eddyQualification ? _self.eddyQualification : eddyQualification // ignore: cast_nullable_to_non_nullable
as String,magneticQualification: null == magneticQualification ? _self.magneticQualification : magneticQualification // ignore: cast_nullable_to_non_nullable
as String,liquidQualification: null == liquidQualification ? _self.liquidQualification : liquidQualification // ignore: cast_nullable_to_non_nullable
as String,ultrasonicQualification: null == ultrasonicQualification ? _self.ultrasonicQualification : ultrasonicQualification // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
