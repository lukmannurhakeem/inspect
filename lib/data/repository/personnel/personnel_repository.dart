
import 'package:file_picker/file_picker.dart';
import 'package:inspect/data/model/personnel_model/personnel_model.dart';
import 'package:inspect/data/model/personnel_team_member_model/personnel_team_member_model.dart';
import 'package:inspect/data/model/personnel_team_model/personnel_team_model.dart';

abstract class PersonnelRepository {
  Future<PersonnelModel> fetchPersonnel();

  Future<Map<String, dynamic>> createPersonnel(
    Map<String, dynamic> personnelData, {
    PlatformFile? signatureFile,
  });

  Future<List<PersonnelTeamModel>> fetchTeamPersonnel();

  Future<Map<String, dynamic>> createTeamPersonnel(
    Map<String, dynamic> personnelData,
  );

  Future<List<PersonnelTeamMemberModel>> fetchTeamMembers(
    String teamPersonnelId,
  );

  Future<AddMemberResponse> addTeamMember(Map<String, dynamic> memberData);

  Future<void> removeTeamMember(String personnelMembersId);

  Future<void> updateTeamMember(
    String personnelMembersId,
    Map<String, dynamic> memberData,
  );

  Future<PersonnelData> updatePersonnelById(
    String personnelId,
    Map<String, dynamic> data, {
    PlatformFile? signatureFile,
  });

  Future<void> deletePersonnelById(String personnelId);

  Future<PersonnelTeamModel> updateTeamById(
    String teamId,
    Map<String, dynamic> data,
  );

  Future<void> deleteTeamById(String teamId);
}
