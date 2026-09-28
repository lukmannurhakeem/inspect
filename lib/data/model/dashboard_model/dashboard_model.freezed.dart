// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardModel {

 CustomerData? get customer; List<SiteData>? get sites; List<JobData>? get jobs; List<ItemData>? get jobItems; List<ReportData>? get reports; StatisticsData? get statistics;
/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardModelCopyWith<DashboardModel> get copyWith => _$DashboardModelCopyWithImpl<DashboardModel>(this as DashboardModel, _$identity);

  /// Serializes this DashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardModel&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.sites, sites)&&const DeepCollectionEquality().equals(other.jobs, jobs)&&const DeepCollectionEquality().equals(other.jobItems, jobItems)&&const DeepCollectionEquality().equals(other.reports, reports)&&(identical(other.statistics, statistics) || other.statistics == statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customer,const DeepCollectionEquality().hash(sites),const DeepCollectionEquality().hash(jobs),const DeepCollectionEquality().hash(jobItems),const DeepCollectionEquality().hash(reports),statistics);

@override
String toString() {
  return 'DashboardModel(customer: $customer, sites: $sites, jobs: $jobs, jobItems: $jobItems, reports: $reports, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class $DashboardModelCopyWith<$Res>  {
  factory $DashboardModelCopyWith(DashboardModel value, $Res Function(DashboardModel) _then) = _$DashboardModelCopyWithImpl;
@useResult
$Res call({
 CustomerData? customer, List<SiteData>? sites, List<JobData>? jobs, List<ItemData>? jobItems, List<ReportData>? reports, StatisticsData? statistics
});


$CustomerDataCopyWith<$Res>? get customer;$StatisticsDataCopyWith<$Res>? get statistics;

}
/// @nodoc
class _$DashboardModelCopyWithImpl<$Res>
    implements $DashboardModelCopyWith<$Res> {
  _$DashboardModelCopyWithImpl(this._self, this._then);

  final DashboardModel _self;
  final $Res Function(DashboardModel) _then;

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customer = freezed,Object? sites = freezed,Object? jobs = freezed,Object? jobItems = freezed,Object? reports = freezed,Object? statistics = freezed,}) {
  return _then(_self.copyWith(
customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerData?,sites: freezed == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteData>?,jobs: freezed == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<JobData>?,jobItems: freezed == jobItems ? _self.jobItems : jobItems // ignore: cast_nullable_to_non_nullable
as List<ItemData>?,reports: freezed == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as List<ReportData>?,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as StatisticsData?,
  ));
}
/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerDataCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerDataCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatisticsDataCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $StatisticsDataCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardModel].
extension DashboardModelPatterns on DashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CustomerData? customer,  List<SiteData>? sites,  List<JobData>? jobs,  List<ItemData>? jobItems,  List<ReportData>? reports,  StatisticsData? statistics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
return $default(_that.customer,_that.sites,_that.jobs,_that.jobItems,_that.reports,_that.statistics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CustomerData? customer,  List<SiteData>? sites,  List<JobData>? jobs,  List<ItemData>? jobItems,  List<ReportData>? reports,  StatisticsData? statistics)  $default,) {final _that = this;
switch (_that) {
case _DashboardModel():
return $default(_that.customer,_that.sites,_that.jobs,_that.jobItems,_that.reports,_that.statistics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CustomerData? customer,  List<SiteData>? sites,  List<JobData>? jobs,  List<ItemData>? jobItems,  List<ReportData>? reports,  StatisticsData? statistics)?  $default,) {final _that = this;
switch (_that) {
case _DashboardModel() when $default != null:
return $default(_that.customer,_that.sites,_that.jobs,_that.jobItems,_that.reports,_that.statistics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardModel implements DashboardModel {
  const _DashboardModel({this.customer, final  List<SiteData>? sites, final  List<JobData>? jobs, final  List<ItemData>? jobItems, final  List<ReportData>? reports, this.statistics}): _sites = sites,_jobs = jobs,_jobItems = jobItems,_reports = reports;
  factory _DashboardModel.fromJson(Map<String, dynamic> json) => _$DashboardModelFromJson(json);

@override final  CustomerData? customer;
 final  List<SiteData>? _sites;
@override List<SiteData>? get sites {
  final value = _sites;
  if (value == null) return null;
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<JobData>? _jobs;
@override List<JobData>? get jobs {
  final value = _jobs;
  if (value == null) return null;
  if (_jobs is EqualUnmodifiableListView) return _jobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ItemData>? _jobItems;
@override List<ItemData>? get jobItems {
  final value = _jobItems;
  if (value == null) return null;
  if (_jobItems is EqualUnmodifiableListView) return _jobItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ReportData>? _reports;
@override List<ReportData>? get reports {
  final value = _reports;
  if (value == null) return null;
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  StatisticsData? statistics;

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardModelCopyWith<_DashboardModel> get copyWith => __$DashboardModelCopyWithImpl<_DashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardModel&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other._sites, _sites)&&const DeepCollectionEquality().equals(other._jobs, _jobs)&&const DeepCollectionEquality().equals(other._jobItems, _jobItems)&&const DeepCollectionEquality().equals(other._reports, _reports)&&(identical(other.statistics, statistics) || other.statistics == statistics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customer,const DeepCollectionEquality().hash(_sites),const DeepCollectionEquality().hash(_jobs),const DeepCollectionEquality().hash(_jobItems),const DeepCollectionEquality().hash(_reports),statistics);

@override
String toString() {
  return 'DashboardModel(customer: $customer, sites: $sites, jobs: $jobs, jobItems: $jobItems, reports: $reports, statistics: $statistics)';
}


}

/// @nodoc
abstract mixin class _$DashboardModelCopyWith<$Res> implements $DashboardModelCopyWith<$Res> {
  factory _$DashboardModelCopyWith(_DashboardModel value, $Res Function(_DashboardModel) _then) = __$DashboardModelCopyWithImpl;
@override @useResult
$Res call({
 CustomerData? customer, List<SiteData>? sites, List<JobData>? jobs, List<ItemData>? jobItems, List<ReportData>? reports, StatisticsData? statistics
});


@override $CustomerDataCopyWith<$Res>? get customer;@override $StatisticsDataCopyWith<$Res>? get statistics;

}
/// @nodoc
class __$DashboardModelCopyWithImpl<$Res>
    implements _$DashboardModelCopyWith<$Res> {
  __$DashboardModelCopyWithImpl(this._self, this._then);

  final _DashboardModel _self;
  final $Res Function(_DashboardModel) _then;

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customer = freezed,Object? sites = freezed,Object? jobs = freezed,Object? jobItems = freezed,Object? reports = freezed,Object? statistics = freezed,}) {
  return _then(_DashboardModel(
customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerData?,sites: freezed == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteData>?,jobs: freezed == jobs ? _self._jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<JobData>?,jobItems: freezed == jobItems ? _self._jobItems : jobItems // ignore: cast_nullable_to_non_nullable
as List<ItemData>?,reports: freezed == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<ReportData>?,statistics: freezed == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as StatisticsData?,
  ));
}

/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerDataCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $CustomerDataCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of DashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatisticsDataCopyWith<$Res>? get statistics {
    if (_self.statistics == null) {
    return null;
  }

  return $StatisticsDataCopyWith<$Res>(_self.statistics!, (value) {
    return _then(_self.copyWith(statistics: value));
  });
}
}


/// @nodoc
mixin _$CustomerData {

 String? get customerId; String? get customerName; String? get siteCode; String? get accountCode; String? get agent; String? get notes; String? get division; String? get logo; String? get address; String? get email; bool? get archived; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDataCopyWith<CustomerData> get copyWith => _$CustomerDataCopyWithImpl<CustomerData>(this as CustomerData, _$identity);

  /// Serializes this CustomerData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerData&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.division, division) || other.division == division)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.email, email) || other.email == email)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerId,customerName,siteCode,accountCode,agent,notes,division,logo,address,email,archived,createdAt,updatedAt);

@override
String toString() {
  return 'CustomerData(customerId: $customerId, customerName: $customerName, siteCode: $siteCode, accountCode: $accountCode, agent: $agent, notes: $notes, division: $division, logo: $logo, address: $address, email: $email, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomerDataCopyWith<$Res>  {
  factory $CustomerDataCopyWith(CustomerData value, $Res Function(CustomerData) _then) = _$CustomerDataCopyWithImpl;
@useResult
$Res call({
 String? customerId, String? customerName, String? siteCode, String? accountCode, String? agent, String? notes, String? division, String? logo, String? address, String? email, bool? archived, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$CustomerDataCopyWithImpl<$Res>
    implements $CustomerDataCopyWith<$Res> {
  _$CustomerDataCopyWithImpl(this._self, this._then);

  final CustomerData _self;
  final $Res Function(CustomerData) _then;

/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = freezed,Object? customerName = freezed,Object? siteCode = freezed,Object? accountCode = freezed,Object? agent = freezed,Object? notes = freezed,Object? division = freezed,Object? logo = freezed,Object? address = freezed,Object? email = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteCode: freezed == siteCode ? _self.siteCode : siteCode // ignore: cast_nullable_to_non_nullable
as String?,accountCode: freezed == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,division: freezed == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerData].
extension CustomerDataPatterns on CustomerData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerData value)  $default,){
final _that = this;
switch (_that) {
case _CustomerData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerData value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? customerId,  String? customerName,  String? siteCode,  String? accountCode,  String? agent,  String? notes,  String? division,  String? logo,  String? address,  String? email,  bool? archived,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
return $default(_that.customerId,_that.customerName,_that.siteCode,_that.accountCode,_that.agent,_that.notes,_that.division,_that.logo,_that.address,_that.email,_that.archived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? customerId,  String? customerName,  String? siteCode,  String? accountCode,  String? agent,  String? notes,  String? division,  String? logo,  String? address,  String? email,  bool? archived,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CustomerData():
return $default(_that.customerId,_that.customerName,_that.siteCode,_that.accountCode,_that.agent,_that.notes,_that.division,_that.logo,_that.address,_that.email,_that.archived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? customerId,  String? customerName,  String? siteCode,  String? accountCode,  String? agent,  String? notes,  String? division,  String? logo,  String? address,  String? email,  bool? archived,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
return $default(_that.customerId,_that.customerName,_that.siteCode,_that.accountCode,_that.agent,_that.notes,_that.division,_that.logo,_that.address,_that.email,_that.archived,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerData implements CustomerData {
  const _CustomerData({this.customerId, this.customerName, this.siteCode, this.accountCode, this.agent, this.notes, this.division, this.logo, this.address, this.email, this.archived, this.createdAt, this.updatedAt});
  factory _CustomerData.fromJson(Map<String, dynamic> json) => _$CustomerDataFromJson(json);

@override final  String? customerId;
@override final  String? customerName;
@override final  String? siteCode;
@override final  String? accountCode;
@override final  String? agent;
@override final  String? notes;
@override final  String? division;
@override final  String? logo;
@override final  String? address;
@override final  String? email;
@override final  bool? archived;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDataCopyWith<_CustomerData> get copyWith => __$CustomerDataCopyWithImpl<_CustomerData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerData&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.division, division) || other.division == division)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.email, email) || other.email == email)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerId,customerName,siteCode,accountCode,agent,notes,division,logo,address,email,archived,createdAt,updatedAt);

@override
String toString() {
  return 'CustomerData(customerId: $customerId, customerName: $customerName, siteCode: $siteCode, accountCode: $accountCode, agent: $agent, notes: $notes, division: $division, logo: $logo, address: $address, email: $email, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerDataCopyWith<$Res> implements $CustomerDataCopyWith<$Res> {
  factory _$CustomerDataCopyWith(_CustomerData value, $Res Function(_CustomerData) _then) = __$CustomerDataCopyWithImpl;
@override @useResult
$Res call({
 String? customerId, String? customerName, String? siteCode, String? accountCode, String? agent, String? notes, String? division, String? logo, String? address, String? email, bool? archived, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$CustomerDataCopyWithImpl<$Res>
    implements _$CustomerDataCopyWith<$Res> {
  __$CustomerDataCopyWithImpl(this._self, this._then);

  final _CustomerData _self;
  final $Res Function(_CustomerData) _then;

/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = freezed,Object? customerName = freezed,Object? siteCode = freezed,Object? accountCode = freezed,Object? agent = freezed,Object? notes = freezed,Object? division = freezed,Object? logo = freezed,Object? address = freezed,Object? email = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CustomerData(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteCode: freezed == siteCode ? _self.siteCode : siteCode // ignore: cast_nullable_to_non_nullable
as String?,accountCode: freezed == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,division: freezed == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SiteData {

 String? get siteId; String? get siteCode; String? get siteName; String? get customerId; String? get area; String? get description; String? get notes; String? get division; String? get logo; String? get address; bool? get archived; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of SiteData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteDataCopyWith<SiteData> get copyWith => _$SiteDataCopyWithImpl<SiteData>(this as SiteData, _$identity);

  /// Serializes this SiteData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteData&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.area, area) || other.area == area)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.division, division) || other.division == division)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteId,siteCode,siteName,customerId,area,description,notes,division,logo,address,archived,createdAt,updatedAt);

@override
String toString() {
  return 'SiteData(siteId: $siteId, siteCode: $siteCode, siteName: $siteName, customerId: $customerId, area: $area, description: $description, notes: $notes, division: $division, logo: $logo, address: $address, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SiteDataCopyWith<$Res>  {
  factory $SiteDataCopyWith(SiteData value, $Res Function(SiteData) _then) = _$SiteDataCopyWithImpl;
@useResult
$Res call({
 String? siteId, String? siteCode, String? siteName, String? customerId, String? area, String? description, String? notes, String? division, String? logo, String? address, bool? archived, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$SiteDataCopyWithImpl<$Res>
    implements $SiteDataCopyWith<$Res> {
  _$SiteDataCopyWithImpl(this._self, this._then);

  final SiteData _self;
  final $Res Function(SiteData) _then;

/// Create a copy of SiteData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteId = freezed,Object? siteCode = freezed,Object? siteName = freezed,Object? customerId = freezed,Object? area = freezed,Object? description = freezed,Object? notes = freezed,Object? division = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,siteCode: freezed == siteCode ? _self.siteCode : siteCode // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,division: freezed == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteData].
extension SiteDataPatterns on SiteData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteData value)  $default,){
final _that = this;
switch (_that) {
case _SiteData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteData value)?  $default,){
final _that = this;
switch (_that) {
case _SiteData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? siteId,  String? siteCode,  String? siteName,  String? customerId,  String? area,  String? description,  String? notes,  String? division,  String? logo,  String? address,  bool? archived,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteData() when $default != null:
return $default(_that.siteId,_that.siteCode,_that.siteName,_that.customerId,_that.area,_that.description,_that.notes,_that.division,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? siteId,  String? siteCode,  String? siteName,  String? customerId,  String? area,  String? description,  String? notes,  String? division,  String? logo,  String? address,  bool? archived,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SiteData():
return $default(_that.siteId,_that.siteCode,_that.siteName,_that.customerId,_that.area,_that.description,_that.notes,_that.division,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? siteId,  String? siteCode,  String? siteName,  String? customerId,  String? area,  String? description,  String? notes,  String? division,  String? logo,  String? address,  bool? archived,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SiteData() when $default != null:
return $default(_that.siteId,_that.siteCode,_that.siteName,_that.customerId,_that.area,_that.description,_that.notes,_that.division,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteData implements SiteData {
  const _SiteData({this.siteId, this.siteCode, this.siteName, this.customerId, this.area, this.description, this.notes, this.division, this.logo, this.address, this.archived, this.createdAt, this.updatedAt});
  factory _SiteData.fromJson(Map<String, dynamic> json) => _$SiteDataFromJson(json);

@override final  String? siteId;
@override final  String? siteCode;
@override final  String? siteName;
@override final  String? customerId;
@override final  String? area;
@override final  String? description;
@override final  String? notes;
@override final  String? division;
@override final  String? logo;
@override final  String? address;
@override final  bool? archived;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of SiteData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteDataCopyWith<_SiteData> get copyWith => __$SiteDataCopyWithImpl<_SiteData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteData&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.area, area) || other.area == area)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.division, division) || other.division == division)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteId,siteCode,siteName,customerId,area,description,notes,division,logo,address,archived,createdAt,updatedAt);

@override
String toString() {
  return 'SiteData(siteId: $siteId, siteCode: $siteCode, siteName: $siteName, customerId: $customerId, area: $area, description: $description, notes: $notes, division: $division, logo: $logo, address: $address, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SiteDataCopyWith<$Res> implements $SiteDataCopyWith<$Res> {
  factory _$SiteDataCopyWith(_SiteData value, $Res Function(_SiteData) _then) = __$SiteDataCopyWithImpl;
@override @useResult
$Res call({
 String? siteId, String? siteCode, String? siteName, String? customerId, String? area, String? description, String? notes, String? division, String? logo, String? address, bool? archived, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$SiteDataCopyWithImpl<$Res>
    implements _$SiteDataCopyWith<$Res> {
  __$SiteDataCopyWithImpl(this._self, this._then);

  final _SiteData _self;
  final $Res Function(_SiteData) _then;

/// Create a copy of SiteData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteId = freezed,Object? siteCode = freezed,Object? siteName = freezed,Object? customerId = freezed,Object? area = freezed,Object? description = freezed,Object? notes = freezed,Object? division = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SiteData(
siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,siteCode: freezed == siteCode ? _self.siteCode : siteCode // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,division: freezed == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$JobData {

 String? get jobId; String? get jobNo; String? get jobName; String? get customerId; String? get status; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of JobData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobDataCopyWith<JobData> get copyWith => _$JobDataCopyWithImpl<JobData>(this as JobData, _$identity);

  /// Serializes this JobData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobData&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNo, jobNo) || other.jobNo == jobNo)&&(identical(other.jobName, jobName) || other.jobName == jobName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,jobNo,jobName,customerId,status,createdAt,updatedAt);

@override
String toString() {
  return 'JobData(jobId: $jobId, jobNo: $jobNo, jobName: $jobName, customerId: $customerId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JobDataCopyWith<$Res>  {
  factory $JobDataCopyWith(JobData value, $Res Function(JobData) _then) = _$JobDataCopyWithImpl;
@useResult
$Res call({
 String? jobId, String? jobNo, String? jobName, String? customerId, String? status, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$JobDataCopyWithImpl<$Res>
    implements $JobDataCopyWith<$Res> {
  _$JobDataCopyWithImpl(this._self, this._then);

  final JobData _self;
  final $Res Function(JobData) _then;

/// Create a copy of JobData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = freezed,Object? jobNo = freezed,Object? jobName = freezed,Object? customerId = freezed,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNo: freezed == jobNo ? _self.jobNo : jobNo // ignore: cast_nullable_to_non_nullable
as String?,jobName: freezed == jobName ? _self.jobName : jobName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobData].
extension JobDataPatterns on JobData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobData value)  $default,){
final _that = this;
switch (_that) {
case _JobData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobData value)?  $default,){
final _that = this;
switch (_that) {
case _JobData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? jobId,  String? jobNo,  String? jobName,  String? customerId,  String? status,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobData() when $default != null:
return $default(_that.jobId,_that.jobNo,_that.jobName,_that.customerId,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? jobId,  String? jobNo,  String? jobName,  String? customerId,  String? status,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JobData():
return $default(_that.jobId,_that.jobNo,_that.jobName,_that.customerId,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? jobId,  String? jobNo,  String? jobName,  String? customerId,  String? status,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobData() when $default != null:
return $default(_that.jobId,_that.jobNo,_that.jobName,_that.customerId,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobData implements JobData {
  const _JobData({this.jobId, this.jobNo, this.jobName, this.customerId, this.status, this.createdAt, this.updatedAt});
  factory _JobData.fromJson(Map<String, dynamic> json) => _$JobDataFromJson(json);

@override final  String? jobId;
@override final  String? jobNo;
@override final  String? jobName;
@override final  String? customerId;
@override final  String? status;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of JobData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobDataCopyWith<_JobData> get copyWith => __$JobDataCopyWithImpl<_JobData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobData&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNo, jobNo) || other.jobNo == jobNo)&&(identical(other.jobName, jobName) || other.jobName == jobName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,jobNo,jobName,customerId,status,createdAt,updatedAt);

@override
String toString() {
  return 'JobData(jobId: $jobId, jobNo: $jobNo, jobName: $jobName, customerId: $customerId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobDataCopyWith<$Res> implements $JobDataCopyWith<$Res> {
  factory _$JobDataCopyWith(_JobData value, $Res Function(_JobData) _then) = __$JobDataCopyWithImpl;
@override @useResult
$Res call({
 String? jobId, String? jobNo, String? jobName, String? customerId, String? status, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$JobDataCopyWithImpl<$Res>
    implements _$JobDataCopyWith<$Res> {
  __$JobDataCopyWithImpl(this._self, this._then);

  final _JobData _self;
  final $Res Function(_JobData) _then;

/// Create a copy of JobData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = freezed,Object? jobNo = freezed,Object? jobName = freezed,Object? customerId = freezed,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_JobData(
jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNo: freezed == jobNo ? _self.jobNo : jobNo // ignore: cast_nullable_to_non_nullable
as String?,jobName: freezed == jobName ? _self.jobName : jobName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ItemData {

 String? get itemId; String? get jobId; String? get jobNo; String? get itemNo; String? get categoryId; String? get categoryName; String? get rfidNo; String? get locationId; String? get detailedLocation; String? get internalNotes; String? get externalNotes; String? get manufacturer; String? get manufacturerAddress; DateTime? get manufacturerDate; DateTime? get firstUseDate; DateTime? get outOfServiceDate; String? get swl; String? get photoReference; String? get standardReference; String? get serialNumber; double? get tareWeight; double? get payLoad; double? get maxGrossWeight; String? get inspectionStatus; String? get description; String? get status; DateTime? get expiryDateTimeStamp; bool? get archived; bool? get canInspectItem; bool? get isActive; bool? get isApproved;
/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDataCopyWith<ItemData> get copyWith => _$ItemDataCopyWithImpl<ItemData>(this as ItemData, _$identity);

  /// Serializes this ItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemData&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNo, jobNo) || other.jobNo == jobNo)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.rfidNo, rfidNo) || other.rfidNo == rfidNo)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.detailedLocation, detailedLocation) || other.detailedLocation == detailedLocation)&&(identical(other.internalNotes, internalNotes) || other.internalNotes == internalNotes)&&(identical(other.externalNotes, externalNotes) || other.externalNotes == externalNotes)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.manufacturerAddress, manufacturerAddress) || other.manufacturerAddress == manufacturerAddress)&&(identical(other.manufacturerDate, manufacturerDate) || other.manufacturerDate == manufacturerDate)&&(identical(other.firstUseDate, firstUseDate) || other.firstUseDate == firstUseDate)&&(identical(other.outOfServiceDate, outOfServiceDate) || other.outOfServiceDate == outOfServiceDate)&&(identical(other.swl, swl) || other.swl == swl)&&(identical(other.photoReference, photoReference) || other.photoReference == photoReference)&&(identical(other.standardReference, standardReference) || other.standardReference == standardReference)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.tareWeight, tareWeight) || other.tareWeight == tareWeight)&&(identical(other.payLoad, payLoad) || other.payLoad == payLoad)&&(identical(other.maxGrossWeight, maxGrossWeight) || other.maxGrossWeight == maxGrossWeight)&&(identical(other.inspectionStatus, inspectionStatus) || other.inspectionStatus == inspectionStatus)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiryDateTimeStamp, expiryDateTimeStamp) || other.expiryDateTimeStamp == expiryDateTimeStamp)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.canInspectItem, canInspectItem) || other.canInspectItem == canInspectItem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,jobId,jobNo,itemNo,categoryId,categoryName,rfidNo,locationId,detailedLocation,internalNotes,externalNotes,manufacturer,manufacturerAddress,manufacturerDate,firstUseDate,outOfServiceDate,swl,photoReference,standardReference,serialNumber,tareWeight,payLoad,maxGrossWeight,inspectionStatus,description,status,expiryDateTimeStamp,archived,canInspectItem,isActive,isApproved]);

@override
String toString() {
  return 'ItemData(itemId: $itemId, jobId: $jobId, jobNo: $jobNo, itemNo: $itemNo, categoryId: $categoryId, categoryName: $categoryName, rfidNo: $rfidNo, locationId: $locationId, detailedLocation: $detailedLocation, internalNotes: $internalNotes, externalNotes: $externalNotes, manufacturer: $manufacturer, manufacturerAddress: $manufacturerAddress, manufacturerDate: $manufacturerDate, firstUseDate: $firstUseDate, outOfServiceDate: $outOfServiceDate, swl: $swl, photoReference: $photoReference, standardReference: $standardReference, serialNumber: $serialNumber, tareWeight: $tareWeight, payLoad: $payLoad, maxGrossWeight: $maxGrossWeight, inspectionStatus: $inspectionStatus, description: $description, status: $status, expiryDateTimeStamp: $expiryDateTimeStamp, archived: $archived, canInspectItem: $canInspectItem, isActive: $isActive, isApproved: $isApproved)';
}


}

/// @nodoc
abstract mixin class $ItemDataCopyWith<$Res>  {
  factory $ItemDataCopyWith(ItemData value, $Res Function(ItemData) _then) = _$ItemDataCopyWithImpl;
@useResult
$Res call({
 String? itemId, String? jobId, String? jobNo, String? itemNo, String? categoryId, String? categoryName, String? rfidNo, String? locationId, String? detailedLocation, String? internalNotes, String? externalNotes, String? manufacturer, String? manufacturerAddress, DateTime? manufacturerDate, DateTime? firstUseDate, DateTime? outOfServiceDate, String? swl, String? photoReference, String? standardReference, String? serialNumber, double? tareWeight, double? payLoad, double? maxGrossWeight, String? inspectionStatus, String? description, String? status, DateTime? expiryDateTimeStamp, bool? archived, bool? canInspectItem, bool? isActive, bool? isApproved
});




}
/// @nodoc
class _$ItemDataCopyWithImpl<$Res>
    implements $ItemDataCopyWith<$Res> {
  _$ItemDataCopyWithImpl(this._self, this._then);

  final ItemData _self;
  final $Res Function(ItemData) _then;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = freezed,Object? jobId = freezed,Object? jobNo = freezed,Object? itemNo = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? rfidNo = freezed,Object? locationId = freezed,Object? detailedLocation = freezed,Object? internalNotes = freezed,Object? externalNotes = freezed,Object? manufacturer = freezed,Object? manufacturerAddress = freezed,Object? manufacturerDate = freezed,Object? firstUseDate = freezed,Object? outOfServiceDate = freezed,Object? swl = freezed,Object? photoReference = freezed,Object? standardReference = freezed,Object? serialNumber = freezed,Object? tareWeight = freezed,Object? payLoad = freezed,Object? maxGrossWeight = freezed,Object? inspectionStatus = freezed,Object? description = freezed,Object? status = freezed,Object? expiryDateTimeStamp = freezed,Object? archived = freezed,Object? canInspectItem = freezed,Object? isActive = freezed,Object? isApproved = freezed,}) {
  return _then(_self.copyWith(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNo: freezed == jobNo ? _self.jobNo : jobNo // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,rfidNo: freezed == rfidNo ? _self.rfidNo : rfidNo // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,detailedLocation: freezed == detailedLocation ? _self.detailedLocation : detailedLocation // ignore: cast_nullable_to_non_nullable
as String?,internalNotes: freezed == internalNotes ? _self.internalNotes : internalNotes // ignore: cast_nullable_to_non_nullable
as String?,externalNotes: freezed == externalNotes ? _self.externalNotes : externalNotes // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,manufacturerAddress: freezed == manufacturerAddress ? _self.manufacturerAddress : manufacturerAddress // ignore: cast_nullable_to_non_nullable
as String?,manufacturerDate: freezed == manufacturerDate ? _self.manufacturerDate : manufacturerDate // ignore: cast_nullable_to_non_nullable
as DateTime?,firstUseDate: freezed == firstUseDate ? _self.firstUseDate : firstUseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,outOfServiceDate: freezed == outOfServiceDate ? _self.outOfServiceDate : outOfServiceDate // ignore: cast_nullable_to_non_nullable
as DateTime?,swl: freezed == swl ? _self.swl : swl // ignore: cast_nullable_to_non_nullable
as String?,photoReference: freezed == photoReference ? _self.photoReference : photoReference // ignore: cast_nullable_to_non_nullable
as String?,standardReference: freezed == standardReference ? _self.standardReference : standardReference // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,tareWeight: freezed == tareWeight ? _self.tareWeight : tareWeight // ignore: cast_nullable_to_non_nullable
as double?,payLoad: freezed == payLoad ? _self.payLoad : payLoad // ignore: cast_nullable_to_non_nullable
as double?,maxGrossWeight: freezed == maxGrossWeight ? _self.maxGrossWeight : maxGrossWeight // ignore: cast_nullable_to_non_nullable
as double?,inspectionStatus: freezed == inspectionStatus ? _self.inspectionStatus : inspectionStatus // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,expiryDateTimeStamp: freezed == expiryDateTimeStamp ? _self.expiryDateTimeStamp : expiryDateTimeStamp // ignore: cast_nullable_to_non_nullable
as DateTime?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,canInspectItem: freezed == canInspectItem ? _self.canInspectItem : canInspectItem // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,isApproved: freezed == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemData].
extension ItemDataPatterns on ItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemData value)  $default,){
final _that = this;
switch (_that) {
case _ItemData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemData value)?  $default,){
final _that = this;
switch (_that) {
case _ItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? itemId,  String? jobId,  String? jobNo,  String? itemNo,  String? categoryId,  String? categoryName,  String? rfidNo,  String? locationId,  String? detailedLocation,  String? internalNotes,  String? externalNotes,  String? manufacturer,  String? manufacturerAddress,  DateTime? manufacturerDate,  DateTime? firstUseDate,  DateTime? outOfServiceDate,  String? swl,  String? photoReference,  String? standardReference,  String? serialNumber,  double? tareWeight,  double? payLoad,  double? maxGrossWeight,  String? inspectionStatus,  String? description,  String? status,  DateTime? expiryDateTimeStamp,  bool? archived,  bool? canInspectItem,  bool? isActive,  bool? isApproved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemData() when $default != null:
return $default(_that.itemId,_that.jobId,_that.jobNo,_that.itemNo,_that.categoryId,_that.categoryName,_that.rfidNo,_that.locationId,_that.detailedLocation,_that.internalNotes,_that.externalNotes,_that.manufacturer,_that.manufacturerAddress,_that.manufacturerDate,_that.firstUseDate,_that.outOfServiceDate,_that.swl,_that.photoReference,_that.standardReference,_that.serialNumber,_that.tareWeight,_that.payLoad,_that.maxGrossWeight,_that.inspectionStatus,_that.description,_that.status,_that.expiryDateTimeStamp,_that.archived,_that.canInspectItem,_that.isActive,_that.isApproved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? itemId,  String? jobId,  String? jobNo,  String? itemNo,  String? categoryId,  String? categoryName,  String? rfidNo,  String? locationId,  String? detailedLocation,  String? internalNotes,  String? externalNotes,  String? manufacturer,  String? manufacturerAddress,  DateTime? manufacturerDate,  DateTime? firstUseDate,  DateTime? outOfServiceDate,  String? swl,  String? photoReference,  String? standardReference,  String? serialNumber,  double? tareWeight,  double? payLoad,  double? maxGrossWeight,  String? inspectionStatus,  String? description,  String? status,  DateTime? expiryDateTimeStamp,  bool? archived,  bool? canInspectItem,  bool? isActive,  bool? isApproved)  $default,) {final _that = this;
switch (_that) {
case _ItemData():
return $default(_that.itemId,_that.jobId,_that.jobNo,_that.itemNo,_that.categoryId,_that.categoryName,_that.rfidNo,_that.locationId,_that.detailedLocation,_that.internalNotes,_that.externalNotes,_that.manufacturer,_that.manufacturerAddress,_that.manufacturerDate,_that.firstUseDate,_that.outOfServiceDate,_that.swl,_that.photoReference,_that.standardReference,_that.serialNumber,_that.tareWeight,_that.payLoad,_that.maxGrossWeight,_that.inspectionStatus,_that.description,_that.status,_that.expiryDateTimeStamp,_that.archived,_that.canInspectItem,_that.isActive,_that.isApproved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? itemId,  String? jobId,  String? jobNo,  String? itemNo,  String? categoryId,  String? categoryName,  String? rfidNo,  String? locationId,  String? detailedLocation,  String? internalNotes,  String? externalNotes,  String? manufacturer,  String? manufacturerAddress,  DateTime? manufacturerDate,  DateTime? firstUseDate,  DateTime? outOfServiceDate,  String? swl,  String? photoReference,  String? standardReference,  String? serialNumber,  double? tareWeight,  double? payLoad,  double? maxGrossWeight,  String? inspectionStatus,  String? description,  String? status,  DateTime? expiryDateTimeStamp,  bool? archived,  bool? canInspectItem,  bool? isActive,  bool? isApproved)?  $default,) {final _that = this;
switch (_that) {
case _ItemData() when $default != null:
return $default(_that.itemId,_that.jobId,_that.jobNo,_that.itemNo,_that.categoryId,_that.categoryName,_that.rfidNo,_that.locationId,_that.detailedLocation,_that.internalNotes,_that.externalNotes,_that.manufacturer,_that.manufacturerAddress,_that.manufacturerDate,_that.firstUseDate,_that.outOfServiceDate,_that.swl,_that.photoReference,_that.standardReference,_that.serialNumber,_that.tareWeight,_that.payLoad,_that.maxGrossWeight,_that.inspectionStatus,_that.description,_that.status,_that.expiryDateTimeStamp,_that.archived,_that.canInspectItem,_that.isActive,_that.isApproved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemData implements ItemData {
  const _ItemData({this.itemId, this.jobId, this.jobNo, this.itemNo, this.categoryId, this.categoryName, this.rfidNo, this.locationId, this.detailedLocation, this.internalNotes, this.externalNotes, this.manufacturer, this.manufacturerAddress, this.manufacturerDate, this.firstUseDate, this.outOfServiceDate, this.swl, this.photoReference, this.standardReference, this.serialNumber, this.tareWeight, this.payLoad, this.maxGrossWeight, this.inspectionStatus, this.description, this.status, this.expiryDateTimeStamp, this.archived, this.canInspectItem, this.isActive, this.isApproved});
  factory _ItemData.fromJson(Map<String, dynamic> json) => _$ItemDataFromJson(json);

@override final  String? itemId;
@override final  String? jobId;
@override final  String? jobNo;
@override final  String? itemNo;
@override final  String? categoryId;
@override final  String? categoryName;
@override final  String? rfidNo;
@override final  String? locationId;
@override final  String? detailedLocation;
@override final  String? internalNotes;
@override final  String? externalNotes;
@override final  String? manufacturer;
@override final  String? manufacturerAddress;
@override final  DateTime? manufacturerDate;
@override final  DateTime? firstUseDate;
@override final  DateTime? outOfServiceDate;
@override final  String? swl;
@override final  String? photoReference;
@override final  String? standardReference;
@override final  String? serialNumber;
@override final  double? tareWeight;
@override final  double? payLoad;
@override final  double? maxGrossWeight;
@override final  String? inspectionStatus;
@override final  String? description;
@override final  String? status;
@override final  DateTime? expiryDateTimeStamp;
@override final  bool? archived;
@override final  bool? canInspectItem;
@override final  bool? isActive;
@override final  bool? isApproved;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDataCopyWith<_ItemData> get copyWith => __$ItemDataCopyWithImpl<_ItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemData&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNo, jobNo) || other.jobNo == jobNo)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.rfidNo, rfidNo) || other.rfidNo == rfidNo)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.detailedLocation, detailedLocation) || other.detailedLocation == detailedLocation)&&(identical(other.internalNotes, internalNotes) || other.internalNotes == internalNotes)&&(identical(other.externalNotes, externalNotes) || other.externalNotes == externalNotes)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.manufacturerAddress, manufacturerAddress) || other.manufacturerAddress == manufacturerAddress)&&(identical(other.manufacturerDate, manufacturerDate) || other.manufacturerDate == manufacturerDate)&&(identical(other.firstUseDate, firstUseDate) || other.firstUseDate == firstUseDate)&&(identical(other.outOfServiceDate, outOfServiceDate) || other.outOfServiceDate == outOfServiceDate)&&(identical(other.swl, swl) || other.swl == swl)&&(identical(other.photoReference, photoReference) || other.photoReference == photoReference)&&(identical(other.standardReference, standardReference) || other.standardReference == standardReference)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.tareWeight, tareWeight) || other.tareWeight == tareWeight)&&(identical(other.payLoad, payLoad) || other.payLoad == payLoad)&&(identical(other.maxGrossWeight, maxGrossWeight) || other.maxGrossWeight == maxGrossWeight)&&(identical(other.inspectionStatus, inspectionStatus) || other.inspectionStatus == inspectionStatus)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiryDateTimeStamp, expiryDateTimeStamp) || other.expiryDateTimeStamp == expiryDateTimeStamp)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.canInspectItem, canInspectItem) || other.canInspectItem == canInspectItem)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,jobId,jobNo,itemNo,categoryId,categoryName,rfidNo,locationId,detailedLocation,internalNotes,externalNotes,manufacturer,manufacturerAddress,manufacturerDate,firstUseDate,outOfServiceDate,swl,photoReference,standardReference,serialNumber,tareWeight,payLoad,maxGrossWeight,inspectionStatus,description,status,expiryDateTimeStamp,archived,canInspectItem,isActive,isApproved]);

@override
String toString() {
  return 'ItemData(itemId: $itemId, jobId: $jobId, jobNo: $jobNo, itemNo: $itemNo, categoryId: $categoryId, categoryName: $categoryName, rfidNo: $rfidNo, locationId: $locationId, detailedLocation: $detailedLocation, internalNotes: $internalNotes, externalNotes: $externalNotes, manufacturer: $manufacturer, manufacturerAddress: $manufacturerAddress, manufacturerDate: $manufacturerDate, firstUseDate: $firstUseDate, outOfServiceDate: $outOfServiceDate, swl: $swl, photoReference: $photoReference, standardReference: $standardReference, serialNumber: $serialNumber, tareWeight: $tareWeight, payLoad: $payLoad, maxGrossWeight: $maxGrossWeight, inspectionStatus: $inspectionStatus, description: $description, status: $status, expiryDateTimeStamp: $expiryDateTimeStamp, archived: $archived, canInspectItem: $canInspectItem, isActive: $isActive, isApproved: $isApproved)';
}


}

/// @nodoc
abstract mixin class _$ItemDataCopyWith<$Res> implements $ItemDataCopyWith<$Res> {
  factory _$ItemDataCopyWith(_ItemData value, $Res Function(_ItemData) _then) = __$ItemDataCopyWithImpl;
@override @useResult
$Res call({
 String? itemId, String? jobId, String? jobNo, String? itemNo, String? categoryId, String? categoryName, String? rfidNo, String? locationId, String? detailedLocation, String? internalNotes, String? externalNotes, String? manufacturer, String? manufacturerAddress, DateTime? manufacturerDate, DateTime? firstUseDate, DateTime? outOfServiceDate, String? swl, String? photoReference, String? standardReference, String? serialNumber, double? tareWeight, double? payLoad, double? maxGrossWeight, String? inspectionStatus, String? description, String? status, DateTime? expiryDateTimeStamp, bool? archived, bool? canInspectItem, bool? isActive, bool? isApproved
});




}
/// @nodoc
class __$ItemDataCopyWithImpl<$Res>
    implements _$ItemDataCopyWith<$Res> {
  __$ItemDataCopyWithImpl(this._self, this._then);

  final _ItemData _self;
  final $Res Function(_ItemData) _then;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = freezed,Object? jobId = freezed,Object? jobNo = freezed,Object? itemNo = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? rfidNo = freezed,Object? locationId = freezed,Object? detailedLocation = freezed,Object? internalNotes = freezed,Object? externalNotes = freezed,Object? manufacturer = freezed,Object? manufacturerAddress = freezed,Object? manufacturerDate = freezed,Object? firstUseDate = freezed,Object? outOfServiceDate = freezed,Object? swl = freezed,Object? photoReference = freezed,Object? standardReference = freezed,Object? serialNumber = freezed,Object? tareWeight = freezed,Object? payLoad = freezed,Object? maxGrossWeight = freezed,Object? inspectionStatus = freezed,Object? description = freezed,Object? status = freezed,Object? expiryDateTimeStamp = freezed,Object? archived = freezed,Object? canInspectItem = freezed,Object? isActive = freezed,Object? isApproved = freezed,}) {
  return _then(_ItemData(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNo: freezed == jobNo ? _self.jobNo : jobNo // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,rfidNo: freezed == rfidNo ? _self.rfidNo : rfidNo // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,detailedLocation: freezed == detailedLocation ? _self.detailedLocation : detailedLocation // ignore: cast_nullable_to_non_nullable
as String?,internalNotes: freezed == internalNotes ? _self.internalNotes : internalNotes // ignore: cast_nullable_to_non_nullable
as String?,externalNotes: freezed == externalNotes ? _self.externalNotes : externalNotes // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,manufacturerAddress: freezed == manufacturerAddress ? _self.manufacturerAddress : manufacturerAddress // ignore: cast_nullable_to_non_nullable
as String?,manufacturerDate: freezed == manufacturerDate ? _self.manufacturerDate : manufacturerDate // ignore: cast_nullable_to_non_nullable
as DateTime?,firstUseDate: freezed == firstUseDate ? _self.firstUseDate : firstUseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,outOfServiceDate: freezed == outOfServiceDate ? _self.outOfServiceDate : outOfServiceDate // ignore: cast_nullable_to_non_nullable
as DateTime?,swl: freezed == swl ? _self.swl : swl // ignore: cast_nullable_to_non_nullable
as String?,photoReference: freezed == photoReference ? _self.photoReference : photoReference // ignore: cast_nullable_to_non_nullable
as String?,standardReference: freezed == standardReference ? _self.standardReference : standardReference // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,tareWeight: freezed == tareWeight ? _self.tareWeight : tareWeight // ignore: cast_nullable_to_non_nullable
as double?,payLoad: freezed == payLoad ? _self.payLoad : payLoad // ignore: cast_nullable_to_non_nullable
as double?,maxGrossWeight: freezed == maxGrossWeight ? _self.maxGrossWeight : maxGrossWeight // ignore: cast_nullable_to_non_nullable
as double?,inspectionStatus: freezed == inspectionStatus ? _self.inspectionStatus : inspectionStatus // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,expiryDateTimeStamp: freezed == expiryDateTimeStamp ? _self.expiryDateTimeStamp : expiryDateTimeStamp // ignore: cast_nullable_to_non_nullable
as DateTime?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,canInspectItem: freezed == canInspectItem ? _self.canInspectItem : canInspectItem // ignore: cast_nullable_to_non_nullable
as bool?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,isApproved: freezed == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$ReportData {

 String? get reportId; String? get reportTypeId; String? get reportTypeName; String? get itemId; String? get itemNo; String? get status; String? get inspectedBy; String? get inspectorName; DateTime? get reportDate; String? get regulation; DateTime? get createdAt; DateTime? get updatedAt; String? get approvalStatus; DateTime? get inspectedOn; String? get inspectStatus; DateTime? get expiryDate;
/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportDataCopyWith<ReportData> get copyWith => _$ReportDataCopyWithImpl<ReportData>(this as ReportData, _$identity);

  /// Serializes this ReportData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportData&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.reportTypeName, reportTypeName) || other.reportTypeName == reportTypeName)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.inspectorName, inspectorName) || other.inspectorName == inspectorName)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.inspectedOn, inspectedOn) || other.inspectedOn == inspectedOn)&&(identical(other.inspectStatus, inspectStatus) || other.inspectStatus == inspectStatus)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportId,reportTypeId,reportTypeName,itemId,itemNo,status,inspectedBy,inspectorName,reportDate,regulation,createdAt,updatedAt,approvalStatus,inspectedOn,inspectStatus,expiryDate);

@override
String toString() {
  return 'ReportData(reportId: $reportId, reportTypeId: $reportTypeId, reportTypeName: $reportTypeName, itemId: $itemId, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, inspectorName: $inspectorName, reportDate: $reportDate, regulation: $regulation, createdAt: $createdAt, updatedAt: $updatedAt, approvalStatus: $approvalStatus, inspectedOn: $inspectedOn, inspectStatus: $inspectStatus, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class $ReportDataCopyWith<$Res>  {
  factory $ReportDataCopyWith(ReportData value, $Res Function(ReportData) _then) = _$ReportDataCopyWithImpl;
@useResult
$Res call({
 String? reportId, String? reportTypeId, String? reportTypeName, String? itemId, String? itemNo, String? status, String? inspectedBy, String? inspectorName, DateTime? reportDate, String? regulation, DateTime? createdAt, DateTime? updatedAt, String? approvalStatus, DateTime? inspectedOn, String? inspectStatus, DateTime? expiryDate
});




}
/// @nodoc
class _$ReportDataCopyWithImpl<$Res>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._self, this._then);

  final ReportData _self;
  final $Res Function(ReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportId = freezed,Object? reportTypeId = freezed,Object? reportTypeName = freezed,Object? itemId = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? inspectorName = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? approvalStatus = freezed,Object? inspectedOn = freezed,Object? inspectStatus = freezed,Object? expiryDate = freezed,}) {
  return _then(_self.copyWith(
reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeName: freezed == reportTypeName ? _self.reportTypeName : reportTypeName // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,inspectorName: freezed == inspectorName ? _self.inspectorName : inspectorName // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,inspectedOn: freezed == inspectedOn ? _self.inspectedOn : inspectedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,inspectStatus: freezed == inspectStatus ? _self.inspectStatus : inspectStatus // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportData].
extension ReportDataPatterns on ReportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportData value)  $default,){
final _that = this;
switch (_that) {
case _ReportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportData value)?  $default,){
final _that = this;
switch (_that) {
case _ReportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reportId,  String? reportTypeId,  String? reportTypeName,  String? itemId,  String? itemNo,  String? status,  String? inspectedBy,  String? inspectorName,  DateTime? reportDate,  String? regulation,  DateTime? createdAt,  DateTime? updatedAt,  String? approvalStatus,  DateTime? inspectedOn,  String? inspectStatus,  DateTime? expiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportData() when $default != null:
return $default(_that.reportId,_that.reportTypeId,_that.reportTypeName,_that.itemId,_that.itemNo,_that.status,_that.inspectedBy,_that.inspectorName,_that.reportDate,_that.regulation,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus,_that.expiryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reportId,  String? reportTypeId,  String? reportTypeName,  String? itemId,  String? itemNo,  String? status,  String? inspectedBy,  String? inspectorName,  DateTime? reportDate,  String? regulation,  DateTime? createdAt,  DateTime? updatedAt,  String? approvalStatus,  DateTime? inspectedOn,  String? inspectStatus,  DateTime? expiryDate)  $default,) {final _that = this;
switch (_that) {
case _ReportData():
return $default(_that.reportId,_that.reportTypeId,_that.reportTypeName,_that.itemId,_that.itemNo,_that.status,_that.inspectedBy,_that.inspectorName,_that.reportDate,_that.regulation,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus,_that.expiryDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reportId,  String? reportTypeId,  String? reportTypeName,  String? itemId,  String? itemNo,  String? status,  String? inspectedBy,  String? inspectorName,  DateTime? reportDate,  String? regulation,  DateTime? createdAt,  DateTime? updatedAt,  String? approvalStatus,  DateTime? inspectedOn,  String? inspectStatus,  DateTime? expiryDate)?  $default,) {final _that = this;
switch (_that) {
case _ReportData() when $default != null:
return $default(_that.reportId,_that.reportTypeId,_that.reportTypeName,_that.itemId,_that.itemNo,_that.status,_that.inspectedBy,_that.inspectorName,_that.reportDate,_that.regulation,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus,_that.expiryDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportData implements ReportData {
  const _ReportData({this.reportId, this.reportTypeId, this.reportTypeName, this.itemId, this.itemNo, this.status, this.inspectedBy, this.inspectorName, this.reportDate, this.regulation, this.createdAt, this.updatedAt, this.approvalStatus, this.inspectedOn, this.inspectStatus, this.expiryDate});
  factory _ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);

@override final  String? reportId;
@override final  String? reportTypeId;
@override final  String? reportTypeName;
@override final  String? itemId;
@override final  String? itemNo;
@override final  String? status;
@override final  String? inspectedBy;
@override final  String? inspectorName;
@override final  DateTime? reportDate;
@override final  String? regulation;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? approvalStatus;
@override final  DateTime? inspectedOn;
@override final  String? inspectStatus;
@override final  DateTime? expiryDate;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportDataCopyWith<_ReportData> get copyWith => __$ReportDataCopyWithImpl<_ReportData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportData&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.reportTypeName, reportTypeName) || other.reportTypeName == reportTypeName)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.inspectorName, inspectorName) || other.inspectorName == inspectorName)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.inspectedOn, inspectedOn) || other.inspectedOn == inspectedOn)&&(identical(other.inspectStatus, inspectStatus) || other.inspectStatus == inspectStatus)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportId,reportTypeId,reportTypeName,itemId,itemNo,status,inspectedBy,inspectorName,reportDate,regulation,createdAt,updatedAt,approvalStatus,inspectedOn,inspectStatus,expiryDate);

@override
String toString() {
  return 'ReportData(reportId: $reportId, reportTypeId: $reportTypeId, reportTypeName: $reportTypeName, itemId: $itemId, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, inspectorName: $inspectorName, reportDate: $reportDate, regulation: $regulation, createdAt: $createdAt, updatedAt: $updatedAt, approvalStatus: $approvalStatus, inspectedOn: $inspectedOn, inspectStatus: $inspectStatus, expiryDate: $expiryDate)';
}


}

/// @nodoc
abstract mixin class _$ReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory _$ReportDataCopyWith(_ReportData value, $Res Function(_ReportData) _then) = __$ReportDataCopyWithImpl;
@override @useResult
$Res call({
 String? reportId, String? reportTypeId, String? reportTypeName, String? itemId, String? itemNo, String? status, String? inspectedBy, String? inspectorName, DateTime? reportDate, String? regulation, DateTime? createdAt, DateTime? updatedAt, String? approvalStatus, DateTime? inspectedOn, String? inspectStatus, DateTime? expiryDate
});




}
/// @nodoc
class __$ReportDataCopyWithImpl<$Res>
    implements _$ReportDataCopyWith<$Res> {
  __$ReportDataCopyWithImpl(this._self, this._then);

  final _ReportData _self;
  final $Res Function(_ReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportId = freezed,Object? reportTypeId = freezed,Object? reportTypeName = freezed,Object? itemId = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? inspectorName = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? approvalStatus = freezed,Object? inspectedOn = freezed,Object? inspectStatus = freezed,Object? expiryDate = freezed,}) {
  return _then(_ReportData(
reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeName: freezed == reportTypeName ? _self.reportTypeName : reportTypeName // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,inspectorName: freezed == inspectorName ? _self.inspectorName : inspectorName // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,inspectedOn: freezed == inspectedOn ? _self.inspectedOn : inspectedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,inspectStatus: freezed == inspectStatus ? _self.inspectStatus : inspectStatus // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StatisticsData {

 int? get totalSites; int? get activeSites; int? get totalJobs; int? get activeJobs; int? get completedJobs; int? get totalItems; int? get activeItems; int? get totalReports; int? get pendingReports; int? get approvedReports; int? get totalNotifications; int? get unreadNotifications; Map<String, dynamic>? get jobsByStatus; Map<String, dynamic>? get itemsByStatus; Map<String, dynamic>? get reportsByStatus; Map<String, dynamic>? get notificationsByType;
/// Create a copy of StatisticsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsDataCopyWith<StatisticsData> get copyWith => _$StatisticsDataCopyWithImpl<StatisticsData>(this as StatisticsData, _$identity);

  /// Serializes this StatisticsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsData&&(identical(other.totalSites, totalSites) || other.totalSites == totalSites)&&(identical(other.activeSites, activeSites) || other.activeSites == activeSites)&&(identical(other.totalJobs, totalJobs) || other.totalJobs == totalJobs)&&(identical(other.activeJobs, activeJobs) || other.activeJobs == activeJobs)&&(identical(other.completedJobs, completedJobs) || other.completedJobs == completedJobs)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.activeItems, activeItems) || other.activeItems == activeItems)&&(identical(other.totalReports, totalReports) || other.totalReports == totalReports)&&(identical(other.pendingReports, pendingReports) || other.pendingReports == pendingReports)&&(identical(other.approvedReports, approvedReports) || other.approvedReports == approvedReports)&&(identical(other.totalNotifications, totalNotifications) || other.totalNotifications == totalNotifications)&&(identical(other.unreadNotifications, unreadNotifications) || other.unreadNotifications == unreadNotifications)&&const DeepCollectionEquality().equals(other.jobsByStatus, jobsByStatus)&&const DeepCollectionEquality().equals(other.itemsByStatus, itemsByStatus)&&const DeepCollectionEquality().equals(other.reportsByStatus, reportsByStatus)&&const DeepCollectionEquality().equals(other.notificationsByType, notificationsByType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSites,activeSites,totalJobs,activeJobs,completedJobs,totalItems,activeItems,totalReports,pendingReports,approvedReports,totalNotifications,unreadNotifications,const DeepCollectionEquality().hash(jobsByStatus),const DeepCollectionEquality().hash(itemsByStatus),const DeepCollectionEquality().hash(reportsByStatus),const DeepCollectionEquality().hash(notificationsByType));

@override
String toString() {
  return 'StatisticsData(totalSites: $totalSites, activeSites: $activeSites, totalJobs: $totalJobs, activeJobs: $activeJobs, completedJobs: $completedJobs, totalItems: $totalItems, activeItems: $activeItems, totalReports: $totalReports, pendingReports: $pendingReports, approvedReports: $approvedReports, totalNotifications: $totalNotifications, unreadNotifications: $unreadNotifications, jobsByStatus: $jobsByStatus, itemsByStatus: $itemsByStatus, reportsByStatus: $reportsByStatus, notificationsByType: $notificationsByType)';
}


}

/// @nodoc
abstract mixin class $StatisticsDataCopyWith<$Res>  {
  factory $StatisticsDataCopyWith(StatisticsData value, $Res Function(StatisticsData) _then) = _$StatisticsDataCopyWithImpl;
@useResult
$Res call({
 int? totalSites, int? activeSites, int? totalJobs, int? activeJobs, int? completedJobs, int? totalItems, int? activeItems, int? totalReports, int? pendingReports, int? approvedReports, int? totalNotifications, int? unreadNotifications, Map<String, dynamic>? jobsByStatus, Map<String, dynamic>? itemsByStatus, Map<String, dynamic>? reportsByStatus, Map<String, dynamic>? notificationsByType
});




}
/// @nodoc
class _$StatisticsDataCopyWithImpl<$Res>
    implements $StatisticsDataCopyWith<$Res> {
  _$StatisticsDataCopyWithImpl(this._self, this._then);

  final StatisticsData _self;
  final $Res Function(StatisticsData) _then;

/// Create a copy of StatisticsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSites = freezed,Object? activeSites = freezed,Object? totalJobs = freezed,Object? activeJobs = freezed,Object? completedJobs = freezed,Object? totalItems = freezed,Object? activeItems = freezed,Object? totalReports = freezed,Object? pendingReports = freezed,Object? approvedReports = freezed,Object? totalNotifications = freezed,Object? unreadNotifications = freezed,Object? jobsByStatus = freezed,Object? itemsByStatus = freezed,Object? reportsByStatus = freezed,Object? notificationsByType = freezed,}) {
  return _then(_self.copyWith(
totalSites: freezed == totalSites ? _self.totalSites : totalSites // ignore: cast_nullable_to_non_nullable
as int?,activeSites: freezed == activeSites ? _self.activeSites : activeSites // ignore: cast_nullable_to_non_nullable
as int?,totalJobs: freezed == totalJobs ? _self.totalJobs : totalJobs // ignore: cast_nullable_to_non_nullable
as int?,activeJobs: freezed == activeJobs ? _self.activeJobs : activeJobs // ignore: cast_nullable_to_non_nullable
as int?,completedJobs: freezed == completedJobs ? _self.completedJobs : completedJobs // ignore: cast_nullable_to_non_nullable
as int?,totalItems: freezed == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int?,activeItems: freezed == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int?,totalReports: freezed == totalReports ? _self.totalReports : totalReports // ignore: cast_nullable_to_non_nullable
as int?,pendingReports: freezed == pendingReports ? _self.pendingReports : pendingReports // ignore: cast_nullable_to_non_nullable
as int?,approvedReports: freezed == approvedReports ? _self.approvedReports : approvedReports // ignore: cast_nullable_to_non_nullable
as int?,totalNotifications: freezed == totalNotifications ? _self.totalNotifications : totalNotifications // ignore: cast_nullable_to_non_nullable
as int?,unreadNotifications: freezed == unreadNotifications ? _self.unreadNotifications : unreadNotifications // ignore: cast_nullable_to_non_nullable
as int?,jobsByStatus: freezed == jobsByStatus ? _self.jobsByStatus : jobsByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,itemsByStatus: freezed == itemsByStatus ? _self.itemsByStatus : itemsByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,reportsByStatus: freezed == reportsByStatus ? _self.reportsByStatus : reportsByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notificationsByType: freezed == notificationsByType ? _self.notificationsByType : notificationsByType // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsData].
extension StatisticsDataPatterns on StatisticsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsData value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsData value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? totalSites,  int? activeSites,  int? totalJobs,  int? activeJobs,  int? completedJobs,  int? totalItems,  int? activeItems,  int? totalReports,  int? pendingReports,  int? approvedReports,  int? totalNotifications,  int? unreadNotifications,  Map<String, dynamic>? jobsByStatus,  Map<String, dynamic>? itemsByStatus,  Map<String, dynamic>? reportsByStatus,  Map<String, dynamic>? notificationsByType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsData() when $default != null:
return $default(_that.totalSites,_that.activeSites,_that.totalJobs,_that.activeJobs,_that.completedJobs,_that.totalItems,_that.activeItems,_that.totalReports,_that.pendingReports,_that.approvedReports,_that.totalNotifications,_that.unreadNotifications,_that.jobsByStatus,_that.itemsByStatus,_that.reportsByStatus,_that.notificationsByType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? totalSites,  int? activeSites,  int? totalJobs,  int? activeJobs,  int? completedJobs,  int? totalItems,  int? activeItems,  int? totalReports,  int? pendingReports,  int? approvedReports,  int? totalNotifications,  int? unreadNotifications,  Map<String, dynamic>? jobsByStatus,  Map<String, dynamic>? itemsByStatus,  Map<String, dynamic>? reportsByStatus,  Map<String, dynamic>? notificationsByType)  $default,) {final _that = this;
switch (_that) {
case _StatisticsData():
return $default(_that.totalSites,_that.activeSites,_that.totalJobs,_that.activeJobs,_that.completedJobs,_that.totalItems,_that.activeItems,_that.totalReports,_that.pendingReports,_that.approvedReports,_that.totalNotifications,_that.unreadNotifications,_that.jobsByStatus,_that.itemsByStatus,_that.reportsByStatus,_that.notificationsByType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? totalSites,  int? activeSites,  int? totalJobs,  int? activeJobs,  int? completedJobs,  int? totalItems,  int? activeItems,  int? totalReports,  int? pendingReports,  int? approvedReports,  int? totalNotifications,  int? unreadNotifications,  Map<String, dynamic>? jobsByStatus,  Map<String, dynamic>? itemsByStatus,  Map<String, dynamic>? reportsByStatus,  Map<String, dynamic>? notificationsByType)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsData() when $default != null:
return $default(_that.totalSites,_that.activeSites,_that.totalJobs,_that.activeJobs,_that.completedJobs,_that.totalItems,_that.activeItems,_that.totalReports,_that.pendingReports,_that.approvedReports,_that.totalNotifications,_that.unreadNotifications,_that.jobsByStatus,_that.itemsByStatus,_that.reportsByStatus,_that.notificationsByType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatisticsData implements StatisticsData {
  const _StatisticsData({this.totalSites, this.activeSites, this.totalJobs, this.activeJobs, this.completedJobs, this.totalItems, this.activeItems, this.totalReports, this.pendingReports, this.approvedReports, this.totalNotifications, this.unreadNotifications, final  Map<String, dynamic>? jobsByStatus, final  Map<String, dynamic>? itemsByStatus, final  Map<String, dynamic>? reportsByStatus, final  Map<String, dynamic>? notificationsByType}): _jobsByStatus = jobsByStatus,_itemsByStatus = itemsByStatus,_reportsByStatus = reportsByStatus,_notificationsByType = notificationsByType;
  factory _StatisticsData.fromJson(Map<String, dynamic> json) => _$StatisticsDataFromJson(json);

@override final  int? totalSites;
@override final  int? activeSites;
@override final  int? totalJobs;
@override final  int? activeJobs;
@override final  int? completedJobs;
@override final  int? totalItems;
@override final  int? activeItems;
@override final  int? totalReports;
@override final  int? pendingReports;
@override final  int? approvedReports;
@override final  int? totalNotifications;
@override final  int? unreadNotifications;
 final  Map<String, dynamic>? _jobsByStatus;
@override Map<String, dynamic>? get jobsByStatus {
  final value = _jobsByStatus;
  if (value == null) return null;
  if (_jobsByStatus is EqualUnmodifiableMapView) return _jobsByStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _itemsByStatus;
@override Map<String, dynamic>? get itemsByStatus {
  final value = _itemsByStatus;
  if (value == null) return null;
  if (_itemsByStatus is EqualUnmodifiableMapView) return _itemsByStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _reportsByStatus;
@override Map<String, dynamic>? get reportsByStatus {
  final value = _reportsByStatus;
  if (value == null) return null;
  if (_reportsByStatus is EqualUnmodifiableMapView) return _reportsByStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _notificationsByType;
@override Map<String, dynamic>? get notificationsByType {
  final value = _notificationsByType;
  if (value == null) return null;
  if (_notificationsByType is EqualUnmodifiableMapView) return _notificationsByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of StatisticsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsDataCopyWith<_StatisticsData> get copyWith => __$StatisticsDataCopyWithImpl<_StatisticsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsData&&(identical(other.totalSites, totalSites) || other.totalSites == totalSites)&&(identical(other.activeSites, activeSites) || other.activeSites == activeSites)&&(identical(other.totalJobs, totalJobs) || other.totalJobs == totalJobs)&&(identical(other.activeJobs, activeJobs) || other.activeJobs == activeJobs)&&(identical(other.completedJobs, completedJobs) || other.completedJobs == completedJobs)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.activeItems, activeItems) || other.activeItems == activeItems)&&(identical(other.totalReports, totalReports) || other.totalReports == totalReports)&&(identical(other.pendingReports, pendingReports) || other.pendingReports == pendingReports)&&(identical(other.approvedReports, approvedReports) || other.approvedReports == approvedReports)&&(identical(other.totalNotifications, totalNotifications) || other.totalNotifications == totalNotifications)&&(identical(other.unreadNotifications, unreadNotifications) || other.unreadNotifications == unreadNotifications)&&const DeepCollectionEquality().equals(other._jobsByStatus, _jobsByStatus)&&const DeepCollectionEquality().equals(other._itemsByStatus, _itemsByStatus)&&const DeepCollectionEquality().equals(other._reportsByStatus, _reportsByStatus)&&const DeepCollectionEquality().equals(other._notificationsByType, _notificationsByType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalSites,activeSites,totalJobs,activeJobs,completedJobs,totalItems,activeItems,totalReports,pendingReports,approvedReports,totalNotifications,unreadNotifications,const DeepCollectionEquality().hash(_jobsByStatus),const DeepCollectionEquality().hash(_itemsByStatus),const DeepCollectionEquality().hash(_reportsByStatus),const DeepCollectionEquality().hash(_notificationsByType));

@override
String toString() {
  return 'StatisticsData(totalSites: $totalSites, activeSites: $activeSites, totalJobs: $totalJobs, activeJobs: $activeJobs, completedJobs: $completedJobs, totalItems: $totalItems, activeItems: $activeItems, totalReports: $totalReports, pendingReports: $pendingReports, approvedReports: $approvedReports, totalNotifications: $totalNotifications, unreadNotifications: $unreadNotifications, jobsByStatus: $jobsByStatus, itemsByStatus: $itemsByStatus, reportsByStatus: $reportsByStatus, notificationsByType: $notificationsByType)';
}


}

/// @nodoc
abstract mixin class _$StatisticsDataCopyWith<$Res> implements $StatisticsDataCopyWith<$Res> {
  factory _$StatisticsDataCopyWith(_StatisticsData value, $Res Function(_StatisticsData) _then) = __$StatisticsDataCopyWithImpl;
@override @useResult
$Res call({
 int? totalSites, int? activeSites, int? totalJobs, int? activeJobs, int? completedJobs, int? totalItems, int? activeItems, int? totalReports, int? pendingReports, int? approvedReports, int? totalNotifications, int? unreadNotifications, Map<String, dynamic>? jobsByStatus, Map<String, dynamic>? itemsByStatus, Map<String, dynamic>? reportsByStatus, Map<String, dynamic>? notificationsByType
});




}
/// @nodoc
class __$StatisticsDataCopyWithImpl<$Res>
    implements _$StatisticsDataCopyWith<$Res> {
  __$StatisticsDataCopyWithImpl(this._self, this._then);

  final _StatisticsData _self;
  final $Res Function(_StatisticsData) _then;

/// Create a copy of StatisticsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSites = freezed,Object? activeSites = freezed,Object? totalJobs = freezed,Object? activeJobs = freezed,Object? completedJobs = freezed,Object? totalItems = freezed,Object? activeItems = freezed,Object? totalReports = freezed,Object? pendingReports = freezed,Object? approvedReports = freezed,Object? totalNotifications = freezed,Object? unreadNotifications = freezed,Object? jobsByStatus = freezed,Object? itemsByStatus = freezed,Object? reportsByStatus = freezed,Object? notificationsByType = freezed,}) {
  return _then(_StatisticsData(
totalSites: freezed == totalSites ? _self.totalSites : totalSites // ignore: cast_nullable_to_non_nullable
as int?,activeSites: freezed == activeSites ? _self.activeSites : activeSites // ignore: cast_nullable_to_non_nullable
as int?,totalJobs: freezed == totalJobs ? _self.totalJobs : totalJobs // ignore: cast_nullable_to_non_nullable
as int?,activeJobs: freezed == activeJobs ? _self.activeJobs : activeJobs // ignore: cast_nullable_to_non_nullable
as int?,completedJobs: freezed == completedJobs ? _self.completedJobs : completedJobs // ignore: cast_nullable_to_non_nullable
as int?,totalItems: freezed == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int?,activeItems: freezed == activeItems ? _self.activeItems : activeItems // ignore: cast_nullable_to_non_nullable
as int?,totalReports: freezed == totalReports ? _self.totalReports : totalReports // ignore: cast_nullable_to_non_nullable
as int?,pendingReports: freezed == pendingReports ? _self.pendingReports : pendingReports // ignore: cast_nullable_to_non_nullable
as int?,approvedReports: freezed == approvedReports ? _self.approvedReports : approvedReports // ignore: cast_nullable_to_non_nullable
as int?,totalNotifications: freezed == totalNotifications ? _self.totalNotifications : totalNotifications // ignore: cast_nullable_to_non_nullable
as int?,unreadNotifications: freezed == unreadNotifications ? _self.unreadNotifications : unreadNotifications // ignore: cast_nullable_to_non_nullable
as int?,jobsByStatus: freezed == jobsByStatus ? _self._jobsByStatus : jobsByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,itemsByStatus: freezed == itemsByStatus ? _self._itemsByStatus : itemsByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,reportsByStatus: freezed == reportsByStatus ? _self._reportsByStatus : reportsByStatus // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notificationsByType: freezed == notificationsByType ? _self._notificationsByType : notificationsByType // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$DashboardResponse {

 bool get success; String get message; DashboardModel get data;
/// Create a copy of DashboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardResponseCopyWith<DashboardResponse> get copyWith => _$DashboardResponseCopyWithImpl<DashboardResponse>(this as DashboardResponse, _$identity);

  /// Serializes this DashboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data);

@override
String toString() {
  return 'DashboardResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $DashboardResponseCopyWith<$Res>  {
  factory $DashboardResponseCopyWith(DashboardResponse value, $Res Function(DashboardResponse) _then) = _$DashboardResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, DashboardModel data
});


$DashboardModelCopyWith<$Res> get data;

}
/// @nodoc
class _$DashboardResponseCopyWithImpl<$Res>
    implements $DashboardResponseCopyWith<$Res> {
  _$DashboardResponseCopyWithImpl(this._self, this._then);

  final DashboardResponse _self;
  final $Res Function(DashboardResponse) _then;

/// Create a copy of DashboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DashboardModel,
  ));
}
/// Create a copy of DashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardModelCopyWith<$Res> get data {
  
  return $DashboardModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardResponse].
extension DashboardResponsePatterns on DashboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _DashboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  DashboardModel data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  DashboardModel data)  $default,) {final _that = this;
switch (_that) {
case _DashboardResponse():
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  DashboardModel data)?  $default,) {final _that = this;
switch (_that) {
case _DashboardResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardResponse implements DashboardResponse {
  const _DashboardResponse({this.success = false, this.message = '', this.data = const DashboardModel()});
  factory _DashboardResponse.fromJson(Map<String, dynamic> json) => _$DashboardResponseFromJson(json);

@override@JsonKey() final  bool success;
@override@JsonKey() final  String message;
@override@JsonKey() final  DashboardModel data;

/// Create a copy of DashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardResponseCopyWith<_DashboardResponse> get copyWith => __$DashboardResponseCopyWithImpl<_DashboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data);

@override
String toString() {
  return 'DashboardResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$DashboardResponseCopyWith<$Res> implements $DashboardResponseCopyWith<$Res> {
  factory _$DashboardResponseCopyWith(_DashboardResponse value, $Res Function(_DashboardResponse) _then) = __$DashboardResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, DashboardModel data
});


@override $DashboardModelCopyWith<$Res> get data;

}
/// @nodoc
class __$DashboardResponseCopyWithImpl<$Res>
    implements _$DashboardResponseCopyWith<$Res> {
  __$DashboardResponseCopyWithImpl(this._self, this._then);

  final _DashboardResponse _self;
  final $Res Function(_DashboardResponse) _then;

/// Create a copy of DashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,}) {
  return _then(_DashboardResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DashboardModel,
  ));
}

/// Create a copy of DashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardModelCopyWith<$Res> get data {
  
  return $DashboardModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$StatisticsResponse {

 bool get success; String get message; StatisticsData get data;
/// Create a copy of StatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsResponseCopyWith<StatisticsResponse> get copyWith => _$StatisticsResponseCopyWithImpl<StatisticsResponse>(this as StatisticsResponse, _$identity);

  /// Serializes this StatisticsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data);

@override
String toString() {
  return 'StatisticsResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $StatisticsResponseCopyWith<$Res>  {
  factory $StatisticsResponseCopyWith(StatisticsResponse value, $Res Function(StatisticsResponse) _then) = _$StatisticsResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, StatisticsData data
});


$StatisticsDataCopyWith<$Res> get data;

}
/// @nodoc
class _$StatisticsResponseCopyWithImpl<$Res>
    implements $StatisticsResponseCopyWith<$Res> {
  _$StatisticsResponseCopyWithImpl(this._self, this._then);

  final StatisticsResponse _self;
  final $Res Function(StatisticsResponse) _then;

/// Create a copy of StatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StatisticsData,
  ));
}
/// Create a copy of StatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatisticsDataCopyWith<$Res> get data {
  
  return $StatisticsDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [StatisticsResponse].
extension StatisticsResponsePatterns on StatisticsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsResponse value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  StatisticsData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  StatisticsData data)  $default,) {final _that = this;
switch (_that) {
case _StatisticsResponse():
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  StatisticsData data)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatisticsResponse implements StatisticsResponse {
  const _StatisticsResponse({this.success = false, this.message = '', this.data = const StatisticsData()});
  factory _StatisticsResponse.fromJson(Map<String, dynamic> json) => _$StatisticsResponseFromJson(json);

@override@JsonKey() final  bool success;
@override@JsonKey() final  String message;
@override@JsonKey() final  StatisticsData data;

/// Create a copy of StatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsResponseCopyWith<_StatisticsResponse> get copyWith => __$StatisticsResponseCopyWithImpl<_StatisticsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data);

@override
String toString() {
  return 'StatisticsResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$StatisticsResponseCopyWith<$Res> implements $StatisticsResponseCopyWith<$Res> {
  factory _$StatisticsResponseCopyWith(_StatisticsResponse value, $Res Function(_StatisticsResponse) _then) = __$StatisticsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, StatisticsData data
});


@override $StatisticsDataCopyWith<$Res> get data;

}
/// @nodoc
class __$StatisticsResponseCopyWithImpl<$Res>
    implements _$StatisticsResponseCopyWith<$Res> {
  __$StatisticsResponseCopyWithImpl(this._self, this._then);

  final _StatisticsResponse _self;
  final $Res Function(_StatisticsResponse) _then;

/// Create a copy of StatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,}) {
  return _then(_StatisticsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StatisticsData,
  ));
}

/// Create a copy of StatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatisticsDataCopyWith<$Res> get data {
  
  return $StatisticsDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ItemsResponse {

 bool get success; String get message; List<ItemData> get data; int get count;
/// Create a copy of ItemsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemsResponseCopyWith<ItemsResponse> get copyWith => _$ItemsResponseCopyWithImpl<ItemsResponse>(this as ItemsResponse, _$identity);

  /// Serializes this ItemsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),count);

@override
String toString() {
  return 'ItemsResponse(success: $success, message: $message, data: $data, count: $count)';
}


}

/// @nodoc
abstract mixin class $ItemsResponseCopyWith<$Res>  {
  factory $ItemsResponseCopyWith(ItemsResponse value, $Res Function(ItemsResponse) _then) = _$ItemsResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, List<ItemData> data, int count
});




}
/// @nodoc
class _$ItemsResponseCopyWithImpl<$Res>
    implements $ItemsResponseCopyWith<$Res> {
  _$ItemsResponseCopyWithImpl(this._self, this._then);

  final ItemsResponse _self;
  final $Res Function(ItemsResponse) _then;

/// Create a copy of ItemsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? count = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ItemData>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemsResponse].
extension ItemsResponsePatterns on ItemsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItemsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItemsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  List<ItemData> data,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemsResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  List<ItemData> data,  int count)  $default,) {final _that = this;
switch (_that) {
case _ItemsResponse():
return $default(_that.success,_that.message,_that.data,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  List<ItemData> data,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ItemsResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemsResponse implements ItemsResponse {
  const _ItemsResponse({this.success = false, this.message = '', final  List<ItemData> data = const [], this.count = 0}): _data = data;
  factory _ItemsResponse.fromJson(Map<String, dynamic> json) => _$ItemsResponseFromJson(json);

@override@JsonKey() final  bool success;
@override@JsonKey() final  String message;
 final  List<ItemData> _data;
@override@JsonKey() List<ItemData> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey() final  int count;

/// Create a copy of ItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemsResponseCopyWith<_ItemsResponse> get copyWith => __$ItemsResponseCopyWithImpl<_ItemsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),count);

@override
String toString() {
  return 'ItemsResponse(success: $success, message: $message, data: $data, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ItemsResponseCopyWith<$Res> implements $ItemsResponseCopyWith<$Res> {
  factory _$ItemsResponseCopyWith(_ItemsResponse value, $Res Function(_ItemsResponse) _then) = __$ItemsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, List<ItemData> data, int count
});




}
/// @nodoc
class __$ItemsResponseCopyWithImpl<$Res>
    implements _$ItemsResponseCopyWith<$Res> {
  __$ItemsResponseCopyWithImpl(this._self, this._then);

  final _ItemsResponse _self;
  final $Res Function(_ItemsResponse) _then;

/// Create a copy of ItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? count = null,}) {
  return _then(_ItemsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ItemData>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
