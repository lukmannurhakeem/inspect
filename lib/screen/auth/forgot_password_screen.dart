import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/service/navigation_service.dart';
import 'package:inspect/core/utils/validators.dart';
import 'package:inspect/providers/authenticate_provider.dart';
import 'package:inspect/widget/auth_scaffold.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _successDelay = Duration(seconds: 2);

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  TextStyle? get _textStyle => context.topology.textTheme.bodyMedium
      ?.copyWith(color: context.colors.primary);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await context
        .read<AuthenticateProvider>()
        .requestPasswordReset(context, _emailController.text.trim());
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) return;
    await Future.delayed(_successDelay);
    if (mounted) NavigationService().goBack();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthLogo(),
            context.vXxl,
            Text(
              'Enter your registered email address below and we will send you a link to reset your password.',
              style: _textStyle,
              textAlign: TextAlign.center,
            ),
            context.vL,
            CommonTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              validator: Validators.email,
              style: _textStyle,
            ),
            context.vL,
            CommonButton(
              text: _isLoading ? 'Sending...' : 'Submit',
              onPressed: _isLoading ? null : _submit,
            ),
            context.vS,
            CommonButton(
              text: 'Cancel',
              backgroundColor: context.colors.secondary,
              onPressed: _isLoading ? null : NavigationService().goBack,
            ),
          ],
        ),
      ),
    );
  }
}
