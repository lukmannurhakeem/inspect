
import 'package:inspect/data/model/user_login_model/user_login_model.dart';
import 'package:inspect/data/model/user_refresh_token_model/user_refresh_token_model.dart';
import 'package:inspect/data/model/user_verify_token_model/user_verify_token_model.dart';
import 'package:inspect/data/model/view_user_model/view_user_model.dart';

abstract class UserRepository {
  Future<UserLoginModel> userLogin(String name, String password);

  Future<UserVerifyTokenModel> userVerifyToken();

  Future<UserRefreshTokenModel> userRefreshToken();

  Future<void> userLogout();

  String? getAccessToken();

  String? getRefreshToken();

  Future<Map<String, dynamic>> userRegister(Map<String, dynamic> registerData);

  Future<ViewUserModel> fetchUserAccess();

  Future<Map<String, dynamic>> forgotPassword(String email);

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword);

  Future<void> updateUser({
    required String userId,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? userGroup,
    String? divisionid,
    String? code,
    bool? passwordReset,
    bool? isAccountLocked,
  });

  Future<void> deleteUser(String userId);
}
