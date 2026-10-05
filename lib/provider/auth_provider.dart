import 'package:flutter/material.dart';
import 'package:inspect/data/model/user_login_model/user_login_model.dart';
import 'package:inspect/data/model/view_user_model/view_user_model.dart';
import 'package:inspect/data/repository/user/user_repository.dart';
import 'package:inspect/errors/app_exception.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';
import 'package:inspect/storage/token_storage.dart';
import 'package:inspect/widget/common_snackbar.dart';

class AuthenticateProvider extends ChangeNotifier {
  static const _sessionKeys = [
    LocalStorageConstant.accessToken,
    LocalStorageConstant.refreshToken,
    LocalStorageConstant.userGroup,
    LocalStorageConstant.userFirstName,
    LocalStorageConstant.userLastName,
    LocalStorageConstant.userEmail,
    LocalStorageConstant.userId,
  ];
  static const _minPasswordLength = 8;
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  AuthenticateProvider({
    UserRepository? userRepository,
    TokenStorage? tokenStorage,
  })  : _userRepository = userRepository ?? ServiceLocator().userRepository,
        _tokenStorage = tokenStorage ?? ServiceLocator().tokenStorage;

  final UserRepository _userRepository;
  final TokenStorage _tokenStorage;

  UserLoginModel? _user;

  List<AuthUser> _users = [];
  bool _isLoadingUsers = false;
  String? _usersErrorMessage;

  UserLoginModel? get user => _user;

  bool get isAdmin => _user?.user?.userGroup?.toLowerCase() == 'admin';

  String get userGroup =>
      LocalStorage.getString(LocalStorageConstant.userGroup);

  List<AuthUser> get users => _users;

  bool get isLoadingUsers => _isLoadingUsers;

  String? get usersErrorMessage => _usersErrorMessage;

  bool get hasUsersError => _usersErrorMessage != null;

  String _messageOf(Object error, {String? fallback}) {
    if (error is AppException) return error.message;
    return fallback ?? error.toString().replaceFirst('Exception:', '').trim();
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) CommonSnackbar.showError(context, message);
  }

  void _showSuccess(BuildContext context, String message) {
    if (context.mounted) CommonSnackbar.showSuccess(context, message);
  }

  Future<void> fetchUsers() async {
    _isLoadingUsers = true;
    _usersErrorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.fetchUserAccess();
      _users = result.users;
    } catch (e) {
      _usersErrorMessage = _messageOf(e, fallback: 'Failed to load users');
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  void clearUsers() {
    _users = [];
    _usersErrorMessage = null;
    notifyListeners();
  }

  Future<bool> _mutateUsers(
      BuildContext context, {
        required Future<void> Function() action,
        required String successMessage,
        bool refreshOnFailure = false,
      }) async {
    _isLoadingUsers = true;
    _usersErrorMessage = null;
    notifyListeners();

    try {
      await action();
      await fetchUsers();
      _showSuccess(context, successMessage);
      return true;
    } catch (e) {
      if (refreshOnFailure) await fetchUsers();
      final message = _messageOf(e);
      _usersErrorMessage = message;
      notifyListeners();
      _showError(context, message);
      return false;
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  Future<bool> updateUser(
      BuildContext context, {
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
      }) {
    return _mutateUsers(
      context,
      action:
          () => _userRepository.updateUser(
        userId: userId,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userGroup: userGroup,
        divisionid: divisionid,
        code: code,
        passwordReset: passwordReset,
        isAccountLocked: isAccountLocked,
      ),
      successMessage: 'User updated successfully',
    );
  }

  Future<bool> deleteUser(BuildContext context, String userId) {
    return _mutateUsers(
      context,
      action: () async {
        await _userRepository.deleteUser(userId);
        _users.removeWhere((u) => u.id == userId);
        notifyListeners();
      },
      successMessage: 'User deleted successfully',
      refreshOnFailure: true,
    );
  }

  Future<UserLoginModel?> login(
      BuildContext context,
      String name,
      String password,
      ) async {
    if (name.trim().isEmpty || password.trim().isEmpty) {
      _showError(context, 'Email and password must not be empty');
      return null;
    }

    final UserLoginModel loginResult;
    try {
      loginResult = await _userRepository.userLogin(name, password);
    } catch (e) {
      _showError(
        context,
        _messageOf(e, fallback: 'Login failed. Please try again.'),
      );
      return null;
    }

    _user = loginResult;
    await _persistProfile(loginResult);
    notifyListeners();

    NavigationService().replaceTo(
      NavigationRoutes.home,
      arguments: {
        'showWelcomeDialog': true,
        'userName':
        '${loginResult.user?.firstName ?? ''} ${loginResult.user?.lastName ?? ''}',
      },
    );
    return loginResult;
  }

  Future<void> _persistProfile(UserLoginModel login) async {
    final profile = login.user;
    await Future.wait([
      LocalStorage.setString(
        LocalStorageConstant.userFirstName,
        profile?.firstName ?? '',
      ),
      LocalStorage.setString(
        LocalStorageConstant.userLastName,
        profile?.lastName ?? '',
      ),
      LocalStorage.setString(
        LocalStorageConstant.userEmail,
        profile?.email ?? '',
      ),
      LocalStorage.setString(
        LocalStorageConstant.userGroup,
        profile?.userGroup ?? '',
      ),
      if (profile?.id != null)
        LocalStorage.setString(
          LocalStorageConstant.userId,
          profile!.id.toString(),
        ),
    ]);
  }

  Future<void> _clearSession() async {
    await _tokenStorage.clearTokens();
    await LocalStorage.removeAll(_sessionKeys);
    _user = null;
  }

  Future<bool> registerUser(
      BuildContext context,
      Map<String, dynamic> registerData,
      ) async {
    try {
      await _userRepository.userRegister(registerData);
      return true;
    } catch (e) {
      _showError(context, _messageOf(e));
      return false;
    }
  }

  Future<void> verifyToken(BuildContext context) async {
    try {
      final hasAccess = (await _tokenStorage.token)?.isNotEmpty == true;
      final hasRefresh = (await _tokenStorage.refreshToken)?.isNotEmpty == true;

      if (!hasAccess && !hasRefresh) return _redirectToLogin();

      final authenticated =
      hasAccess ? await _isTokenValid() : await _refreshSession();

      if (authenticated) {
        NavigationService().navigateToAndRemoveUntil(NavigationRoutes.home);
      } else {
        await _redirectToLogin();
      }
    } catch (_) {
      await _redirectToLogin();
    }
  }

  Future<bool> _isTokenValid() async {
    try {
      final response = await _userRepository.userVerifyToken();
      if (response.valid == true) return true;
      return _refreshSession();
    } catch (_) {
      return _refreshSession();
    }
  }

  Future<bool> _refreshSession() async {
    try {
      final expiry = await _tokenStorage.refreshExpiry;
      if (expiry != null && expiry.isBefore(DateTime.now())) return false;

      final response = await _userRepository.userRefreshToken();
      return response.accessToken?.isNotEmpty == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> handleSessionExpired() => _redirectToLogin();

  Future<void> _redirectToLogin() async {
    await _clearSession();
    clearUsers();
    NavigationService().navigateToAndRemoveUntil(NavigationRoutes.login);
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _userRepository.userLogout();
    } catch (_) {
      // Log out locally even if the server call fails.
    }
    await _redirectToLogin();
  }

  Future<bool> requestPasswordReset(BuildContext context, String email) async {
    if (email.trim().isEmpty) {
      _showError(context, 'Email address is required');
      return false;
    }
    if (!_emailRegex.hasMatch(email)) {
      _showError(context, 'Please enter a valid email address');
      return false;
    }

    try {
      final result = await _userRepository.forgotPassword(email);
      if (result['success'] == true) {
        _showSuccess(
          context,
          result['message'] ?? 'Password reset link sent to your email',
        );
        return true;
      }
      _showError(context, 'Failed to send reset email');
      return false;
    } catch (e) {
      _showError(
        context,
        _messageOf(
          e,
          fallback: 'Failed to send reset email. Please try again.',
        ),
      );
      return false;
    }
  }

  Future<bool> resetPassword(
      BuildContext context,
      String token,
      String newPassword,
      String confirmPassword,
      ) async {
    final validationError = _validateResetPassword(
      token,
      newPassword,
      confirmPassword,
    );
    if (validationError != null) {
      _showError(context, validationError);
      return false;
    }

    try {
      final result = await _userRepository.resetPassword(token, newPassword);
      if (result['success'] == true) {
        _showSuccess(
          context,
          result['message'] ?? 'Password reset successfully',
        );
        return true;
      }
      _showError(context, 'Failed to reset password');
      return false;
    } catch (e) {
      _showError(
        context,
        _messageOf(e, fallback: 'Failed to reset password. Please try again.'),
      );
      return false;
    }
  }

  String? _validateResetPassword(
      String token,
      String newPassword,
      String confirmPassword,
      ) {
    if (token.trim().isEmpty) return 'Invalid reset token';
    if (newPassword.trim().isEmpty || confirmPassword.trim().isEmpty) {
      return 'Password fields cannot be empty';
    }
    if (newPassword != confirmPassword) return 'Passwords do not match';
    if (newPassword.length < _minPasswordLength) {
      return 'Password must be at least $_minPasswordLength characters';
    }
    return null;
  }
}