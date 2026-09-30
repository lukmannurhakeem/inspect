import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/service/navigation_service.dart';
import 'package:inspect/core/utils/validators.dart';
import 'package:inspect/providers/authenticate_provider.dart';
import 'package:inspect/route/route.dart';
import 'package:inspect/widget/auth_scaffold.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const _redirectDelay = Duration(seconds: 2);

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _token;
  bool _tokenResolved = false;
  bool _isLoading = false;

  TextStyle? get _fieldStyle => context.topology.textTheme.bodyMedium
      ?.copyWith(color: context.colors.primary);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tokenResolved) return;
    _tokenResolved = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    final token = args is Map ? args['token']?.toString() : null;

    if (token == null || token.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _rejectToken());
    } else {
      _token = token;
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _rejectToken() async {
    if (!mounted) return;
    CommonSnackbar.showError(
      context,
      'Invalid or missing reset token. Please request a new password reset.',
    );
    await Future.delayed(_redirectDelay);
    _goToLogin();
  }

  void _goToLogin() {
    if (mounted) NavigationService().replaceTo(AppRoutes.login);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = _token;
    if (token == null) {
      CommonSnackbar.showError(context, 'Invalid reset token');
      return;
    }

    setState(() => _isLoading = true);
    final success = await context.read<AuthenticateProvider>().resetPassword(
      context,
      token,
      _newPasswordController.text.trim(),
      _confirmPasswordController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) return;
    await Future.delayed(_redirectDelay);
    _goToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AuthLogo()),
            context.vXxl,
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_reset, size: 48, color: primary),
              ),
            ),
            context.vL,
            Text(
              'Create New Password',
              style: textTheme.headlineSmall?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            context.vS,
            Text(
              'Your new password must be different from previously used passwords.',
              style: textTheme.bodyMedium?.copyWith(
                color: primary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            context.vXl,
            const _PasswordRequirements(),
            context.vL,
            CommonTextField(
              controller: _newPasswordController,
              labelText: 'New Password',
              hintText: 'Enter your new password',
              obscureText: true,
              showPasswordToggle: true,
              keyboardType: TextInputType.visiblePassword,
              enabled: !_isLoading,
              prefixIcon: Icon(Icons.lock_outline, color: primary),
              validator: Validators.newPassword,
              style: _fieldStyle,
            ),
            context.vM,
            CommonTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Re-enter your new password',
              obscureText: true,
              showPasswordToggle: true,
              keyboardType: TextInputType.visiblePassword,
              enabled: !_isLoading,
              prefixIcon: Icon(Icons.lock_outline, color: primary),
              validator: Validators.confirmPassword(_newPasswordController),
              style: _fieldStyle,
            ),
            context.vXl,
            CommonButton(
              text: _isLoading ? 'Resetting Password...' : 'Reset Password',
              onPressed: _isLoading ? null : _submit,
            ),
            context.vM,
            CommonButton(
              text: 'Back to Login',
              backgroundColor: context.colors.secondary,
              onPressed: _isLoading ? null : _goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements();

  static const _requirements = [
    'At least 8 characters',
    'Both letters and numbers',
  ];

  @override
  Widget build(BuildContext context) {
    final smallText = context.topology.textTheme.bodySmall;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: smallText?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          for (final requirement in _requirements)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    requirement,
                    style: smallText?.copyWith(color: Colors.blue.shade900),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
