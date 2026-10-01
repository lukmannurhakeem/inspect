import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/personnel_model/personnel_model.dart';
import 'package:inspect/data/model/personnel_team_member_model/personnel_team_member_model.dart';
import 'package:inspect/data/model/personnel_team_model/personnel_team_model.dart';
import 'package:inspect/data/repository/personnel/personnel_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/storage/local_storage.dart';

class PersonnelProvider extends ChangeNotifier {
  static const _cacheKey = 'cached_personnel_list';

  final PersonnelRepository _repository = ServiceLocator().personnelRepository;

  PersonnelModel? _personnelModel;
  List<PersonnelTeamModel> _teams = [];
  List<PersonnelTeamMemberModel> _teamMembers = [];
  bool _isLoading = false;
  String? _errorMessage;

  PersonnelModel? get personnelModel => _personnelModel;
  List<PersonnelTeamModel> get teamPersonnelList => _teams;
  List<PersonnelTeamMemberModel> get teamMembers => _teamMembers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<PersonnelData> get personnelList => _personnelModel?.data ?? [];
  int get personnelCount => _personnelModel?.count ?? 0;
  int get teamPersonnelCount => _teams.length;

  List<PersonnelData> get activePersonnel =>
      personnelList.where((p) => !p.personnel.isArchived).toList();

  List<PersonnelData> get visibleInPlanner =>
      personnelList.where((p) => !p.personnel.isHiddenFromPlanner).toList();

  Future<T?> _run<T>(
      Future<T> Function() action, {
        required String errorPrefix,
        bool showLoading = true,
        T? onErrorValue,
      }) async {
    if (showLoading) _setLoading(true);
    _clearError();
    try {
      return await action();
    } catch (e) {
      _setError('$errorPrefix: $e');
      return onErrorValue;
    } finally {
      if (showLoading) _setLoading(false);
    }
  }

  Future<bool> _runBool(
      Future<void> Function() action, {
        required String errorPrefix,
      }) async {
    final result = await _run<bool>(
          () async {
        await action();
        return true;
      },
      errorPrefix: errorPrefix,
      onErrorValue: false,
    );
    return result ?? false;
  }

  Future<void> fetchPersonnel() async {
    _setLoading(true);
    _clearError();
    try {
      if (!await _isOnline()) {
        _loadFromCache();
        return;
      }
      _personnelModel = await _repository.fetchPersonnel();
      await LocalStorage.setString(
        _cacheKey,
        jsonEncode(_personnelModel?.toJson() ?? {}),
      );
      notifyListeners();
    } catch (e) {
      _loadFromCache();
      if (personnelList.isEmpty) {
        _setError('Failed to fetch personnel: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshPersonnel() => fetchPersonnel();

  Future<void> fetchTeamPersonnel() async {
    final result = await _run<List<PersonnelTeamModel>>(
      _repository.fetchTeamPersonnel,
      errorPrefix: 'Failed to fetch team personnel',
      onErrorValue: [],
    );
    _teams = result ?? [];
    notifyListeners();
  }

  Future<void> refreshTeamPersonnel() => fetchTeamPersonnel();

  Future<void> fetchTeamMembers(String teamPersonnelId) async {
    final result = await _run<List<PersonnelTeamMemberModel>>(
          () => _repository.fetchTeamMembers(teamPersonnelId),
      errorPrefix: 'Failed to fetch team members',
      onErrorValue: [],
    );
    _teamMembers = result ?? [];
    notifyListeners();
  }

  void clearTeamMembers() {
    _teamMembers = [];
    notifyListeners();
  }

  List<PersonnelData> searchPersonnel(String query) {
    if (query.isEmpty) return personnelList;
    final q = query.toLowerCase();
    return personnelList.where((p) {
      return p.fullName.toLowerCase().contains(q) ||
          p.displayName.toLowerCase().contains(q) ||
          p.company.jobTitle.toLowerCase().contains(q) ||
          p.company.employeeNumber.toLowerCase().contains(q);
    }).toList();
  }

  List<PersonnelTeamModel> searchTeams(String query) {
    if (query.isEmpty) return _teams;
    final q = query.toLowerCase();
    bool matches(String? value) => value?.toLowerCase().contains(q) ?? false;
    return _teams
        .where(
          (t) => matches(t.name) || matches(t.type) || matches(t.description),
    )
        .toList();
  }

  List<PersonnelData> filterByJobTitle(String jobTitle) {
    if (jobTitle.isEmpty) return personnelList;
    final q = jobTitle.toLowerCase();
    return personnelList
        .where((p) => p.company.jobTitle.toLowerCase().contains(q))
        .toList();
  }

  PersonnelData? getPersonnelById(String personnelId) {
    for (final p in personnelList) {
      if (p.personnel.personnelID == personnelId) return p;
    }
    return null;
  }

  PersonnelData? getPersonnelForMember(String personnelId) =>
      getPersonnelById(personnelId);

  PersonnelTeamModel? getTeamById(String teamId) {
    for (final t in _teams) {
      if (t.teamPersonnelId == teamId) return t;
    }
    return null;
  }

  Future<bool> createPersonnel(
      Map<String, dynamic> personnelData, {
        PlatformFile? signatureFile,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.createPersonnel(
        personnelData,
        signatureFile: signatureFile,
      );
      if (result['queued'] == true) {
        _errorMessage = result['message'];
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTeamPersonnel(Map<String, dynamic> data) {
    return _runBool(() async {
      await _repository.createTeamPersonnel(data);
      await fetchTeamPersonnel();
    }, errorPrefix: 'Failed to create team');
  }

  Future<bool> updatePersonnel(
      String personnelId,
      Map<String, dynamic> data, {
        PlatformFile? signatureFile,
      }) {
    return _runBool(() async {
      final updated = await _repository.updatePersonnelById(
        personnelId,
        data,
        signatureFile: signatureFile,
      );
      final list = _personnelModel?.data;
      final index =
          list?.indexWhere((p) => p.personnel.personnelID == personnelId) ?? -1;
      if (index >= 0) {
        list![index] = updated;
        notifyListeners();
      }
    }, errorPrefix: 'Failed to update personnel');
  }

  Future<bool> updateTeamPersonnel(String teamId, Map<String, dynamic> data) {
    return _runBool(() async {
      final updated = await _repository.updateTeamById(teamId, data);
      final index = _teams.indexWhere((t) => t.teamPersonnelId == teamId);
      if (index >= 0) {
        _teams[index] = updated;
        notifyListeners();
      }
    }, errorPrefix: 'Failed to update team');
  }

  Future<bool> deletePersonnel(String personnelId) {
    return _runBool(() async {
      await _repository.deletePersonnelById(personnelId);
      _personnelModel?.data.removeWhere(
            (p) => p.personnel.personnelID == personnelId,
      );
      notifyListeners();
    }, errorPrefix: 'Failed to delete personnel');
  }

  Future<bool> deleteTeamPersonnel(String teamId) {
    return _runBool(() async {
      await _repository.deleteTeamById(teamId);
      _teams.removeWhere((t) => t.teamPersonnelId == teamId);
      notifyListeners();
    }, errorPrefix: 'Failed to delete team');
  }

  Future<bool> addTeamMember(Map<String, dynamic> memberData) {
    return _runBool(() async {
      await _repository.addTeamMember(memberData);
      final teamId = memberData['team_personnel_id'];
      if (teamId != null) await fetchTeamMembers(teamId);
    }, errorPrefix: 'Failed to add team member');
  }

  Future<bool> removeTeamMember(
      String personnelMembersId,
      String teamPersonnelId,
      ) {
    return _runBool(() async {
      await _repository.removeTeamMember(personnelMembersId);
      await fetchTeamMembers(teamPersonnelId);
    }, errorPrefix: 'Failed to remove team member');
  }

  Future<bool> updateTeamMember(
      String personnelMembersId,
      String teamPersonnelId,
      Map<String, dynamic> memberData,
      ) {
    return _runBool(() async {
      await _repository.updateTeamMember(personnelMembersId, memberData);
      await fetchTeamMembers(teamPersonnelId);
    }, errorPrefix: 'Failed to update team member');
  }

  void clearData() {
    _personnelModel = null;
    _teams = [];
    _teamMembers = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  void _loadFromCache() {
    try {
      final raw = LocalStorage.getString(_cacheKey);
      if (raw.isEmpty) return;
      _personnelModel = PersonnelModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load cached personnel: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() => _errorMessage = null;
}