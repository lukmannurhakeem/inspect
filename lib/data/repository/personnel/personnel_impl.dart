import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:inspect/data/model/personnel_model/personnel_model.dart';
import 'package:inspect/data/model/personnel_team_member_model/personnel_team_member_model.dart';
import 'package:inspect/data/model/personnel_team_model/personnel_team_model.dart';
import 'package:inspect/data/repository/personnel/personnel_repository.dart';
import 'package:inspect/errors/app_exception.dart';
import 'package:inspect/errors/error_handler.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class PersonnelImpl implements PersonnelRepository {
  final ApiClient _api;

  PersonnelImpl(this._api);

  @override
  Future<PersonnelModel> fetchPersonnel() => _api.get(
    ApiEndpoint.personnelView,
    parser: (data) => PersonnelModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<Map<String, dynamic>> createPersonnel(
      Map<String, dynamic> personnelData, {
        PlatformFile? signatureFile,
      }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.personnelCreate,
      data: await _buildFormData(personnelData, signatureFile),
    );

    if (_isQueued(data)) {
      return {
        'message': 'Personnel saved locally. Will sync when online.',
        'queued': true,
      };
    }
    return Map<String, dynamic>.from(data as Map);
  }

  @override
  Future<PersonnelData> updatePersonnelById(
      String personnelId,
      Map<String, dynamic> data, {
        PlatformFile? signatureFile,
      }) async => _api.patch(
    '${ApiEndpoint.personnelUpdate}/$personnelId',
    data: await _buildFormData(data, signatureFile),
    parser: (data) => PersonnelData.fromJson(
      (data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    ),
  );

  @override
  Future<void> deletePersonnelById(String personnelId) =>
      _api.delete<dynamic>('${ApiEndpoint.personnelDelete}/$personnelId');

  @override
  Future<List<PersonnelTeamModel>> fetchTeamPersonnel() => _api.get(
    ApiEndpoint.personnelTeamView,
    parser: _parseTeams,
  );

  @override
  Future<Map<String, dynamic>> createTeamPersonnel(
      Map<String, dynamic> personnelTeamData,
      ) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.personnelTeamCreate,
      data: personnelTeamData,
    );

    if (_isQueued(data)) {
      return {
        'message': 'Team saved locally. Will sync when online.',
        'queued': true,
      };
    }
    return Map<String, dynamic>.from(data as Map);
  }

  @override
  Future<PersonnelTeamModel> updateTeamById(
      String teamId,
      Map<String, dynamic> data,
      ) => _api.patch(
    '${ApiEndpoint.personnelTeamUpdate}/$teamId',
    data: data,
    parser: (data) =>
        PersonnelTeamModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> deleteTeamById(String teamId) =>
      _api.delete<dynamic>('${ApiEndpoint.personnelTeamDelete}/$teamId');

  @override
  Future<List<PersonnelTeamMemberModel>> fetchTeamMembers(
      String teamPersonnelId,
      ) => _api.get(
    '${ApiEndpoint.personnelMembersView}/$teamPersonnelId',
    parser: _parseMembers,
  );

  @override
  Future<AddMemberResponse> addTeamMember(
      Map<String, dynamic> memberData,
      ) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.personnelMembersAdd,
      data: memberData,
    );

    if (_isQueued(data)) {
      return AddMemberResponse(
        message: 'Member addition queued. Will sync when online.',
        data: data,
      );
    }
    return AddMemberResponse.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> removeTeamMember(String personnelMembersId) async {
    final data = await _api.delete<dynamic>(
      '${ApiEndpoint.personnelMembersDelete}/$personnelMembersId',
    );

    if (_isQueued(data)) {
      throw const NetworkException(
        'Member removal queued. Will sync when online.',
      );
    }
  }

  @override
  Future<void> updateTeamMember(
      String personnelMembersId,
      Map<String, dynamic> memberData,
      ) async {
    final data = await _api.put<dynamic>(
      '${ApiEndpoint.personnelMembersUpdate}/$personnelMembersId',
      data: memberData,
    );

    if (_isQueued(data)) {
      throw const NetworkException(
        'Member update queued. Will sync when online.',
      );
    }
  }

  static bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

  static Future<FormData> _buildFormData(
      Map<String, dynamic> personnelData,
      PlatformFile? signatureFile,
      ) async {
    try {
      final cleanData = Map<String, dynamic>.from(personnelData)
        ..remove('signatureFile');

      final formData = FormData()
        ..fields.add(MapEntry('personnelData', jsonEncode(cleanData)));

      if (signatureFile != null) {
        final MultipartFile? file;
        if (kIsWeb && signatureFile.bytes != null) {
          file = MultipartFile.fromBytes(
            signatureFile.bytes!,
            filename: signatureFile.name,
          );
        } else if (signatureFile.path != null) {
          file = await MultipartFile.fromFile(
            signatureFile.path!,
            filename: signatureFile.name,
          );
        } else {
          file = null;
        }
        if (file != null) formData.files.add(MapEntry('signatureFile', file));
      }

      return formData;
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  static List<PersonnelTeamModel> _parseTeams(dynamic data) {
    List<PersonnelTeamModel> fromList(List list) => list
        .map((e) => PersonnelTeamModel.fromJson(e as Map<String, dynamic>))
        .toList();

    if (data is List) return fromList(data);
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) return fromList(inner);
      return [PersonnelTeamModel.fromJson(data)];
    }
    return [];
  }

  static List<PersonnelTeamMemberModel> _parseMembers(dynamic data) {
    List<PersonnelTeamMemberModel> fromList(List list) => list
        .map(
          (e) => PersonnelTeamMemberModel.fromJson(e as Map<String, dynamic>),
    )
        .toList();

    if (data is List) return fromList(data);
    if (data is Map<String, dynamic>) {
      if (data['members'] is List) return fromList(data['members'] as List);

      final inner = data['data'];
      if (inner is Map<String, dynamic> && inner.containsKey('members')) {
        return fromList(inner['members'] as List);
      }
      if (inner is List) return fromList(inner);

      return [PersonnelTeamMemberModel.fromJson(data)];
    }
    return [];
  }
}