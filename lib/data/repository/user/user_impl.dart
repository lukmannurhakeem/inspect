import 'package:inspect/data/model/user_login_model/user_login_model.dart';
import 'package:inspect/data/model/user_refresh_token_model/user_refresh_token_model.dart';
import 'package:inspect/data/model/user_verify_token_model/user_verify_token_model.dart';
import 'package:inspect/data/model/view_user_model/view_user_model.dart';
import 'package:inspect/data/repository/user/user_repository.dart';
import 'package:inspect/errors/app_exception.dart';
import 'package:inspect/errors/error_handler.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/storage/token_storage.dart';

class UserImpl implements UserRepository {
  final ApiClient _api;
  final TokenStorage _tokenStorage;

  UserImpl(this._api, this._tokenStorage);

  static DateTime _defaultRefreshExpiry() =>
      DateTime.now().add(const Duration(days: 30));

  @override
  Future<UserLoginModel> userLogin(String name, String password) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        ApiEndpoint.login,
        data: {'email': name, 'password': password},
      );

      final accessToken = response['access_token'] as String?;
      final refreshToken = response['refresh_token'] as String?;

      if (accessToken == null || accessToken.isEmpty) {
        throw UnknownException('No access token in response');
      }

      await _tokenStorage.saveTokens(
        token: accessToken,
        refreshToken: refreshToken ?? '',
        refreshExpiry: _defaultRefreshExpiry(),
      );

      return UserLoginModel.fromJson(response);
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  @override
  Future<UserVerifyTokenModel> userVerifyToken() => _api.get(
    ApiEndpoint.verifyToken,
    parser: (data) =>
        UserVerifyTokenModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<UserRefreshTokenModel> userRefreshToken() async {
    try {
      final refreshTokenValue = await _tokenStorage.refreshToken;

      final response = await _api.post<Map<String, dynamic>>(
        ApiEndpoint.refreshToken,
        data: {'refresh_token': refreshTokenValue},
      );

      final accessToken = response['access_token'] as String?;
      final refreshToken = response['refresh_token'] as String?;

      if (accessToken != null && accessToken.isNotEmpty) {
        await _tokenStorage.saveTokens(
          token: accessToken,
          refreshToken: refreshToken ?? refreshTokenValue ?? '',
          refreshExpiry: _defaultRefreshExpiry(),
        );
      }

      return UserRefreshTokenModel.fromJson(response);
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  @override
  Future<void> userLogout() async {
    try {
      final refreshTokenValue = await _tokenStorage.refreshToken;

      await _api.post<dynamic>(
        ApiEndpoint.logout,
        data: {'refresh_token': refreshTokenValue},
      );
    } catch (_) {
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  @override
  String? getAccessToken() => null;

  @override
  String? getRefreshToken() => null;

  @override
  Future<Map<String, dynamic>> userRegister(
      Map<String, dynamic> registerData,
      ) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.userRegister,
      data: registerData,
    );

    if (_isQueued(data)) {
      return {
        'message': 'User registration saved locally. Will sync when online.',
        'queued': true,
        'requestId': data['requestId'],
      };
    }

    return _mapOrEmpty(data);
  }

  @override
  Future<ViewUserModel> fetchUserAccess() => _api.get(
    ApiEndpoint.users,
    parser: (data) => ViewUserModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _api.post<dynamic>(
        ApiEndpoint.forgotPassword,
        data: {'email': email},
      );

      final map = _mapOrEmpty(response);
      return {
        'success': true,
        'message': map['message'] ?? 'Password reset link sent to your email',
        'data': response,
      };
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String token,
      String newPassword,
      ) async {
    try {
      final response = await _api.post<dynamic>(
        ApiEndpoint.resetPassword,
        data: {'token': token, 'new_password': newPassword},
      );

      final map = _mapOrEmpty(response);
      return {
        'success': true,
        'message': map['message'] ?? 'Password reset successfully',
        'data': response,
      };
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  @override
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
  }) async {
    final data = await _api.patch<dynamic>(
      ApiEndpoint.userUpdate(userId),
      data: {
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (userGroup != null) 'user_group': userGroup,
        if (divisionid != null) 'divisionid': divisionid,
        if (code != null) 'code': code,
        if (passwordReset != null) 'password_reset': passwordReset,
        if (isAccountLocked != null) 'is_account_locked': isAccountLocked,
      },
    );

    _throwIfQueued(data, 'User update queued. Will sync when online.');
  }

  @override
  Future<void> deleteUser(String userId) async {
    final data = await _api.delete<dynamic>(ApiEndpoint.userDelete(userId));
    _throwIfQueued(data, 'User deletion queued. Will sync when online.');
  }

  static bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

  static void _throwIfQueued(dynamic data, String message) {
    if (_isQueued(data)) throw NetworkException(message);
  }

  static Map<String, dynamic> _mapOrEmpty(dynamic data) =>
      data is Map<String, dynamic> ? data : <String, dynamic>{};
}