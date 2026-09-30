import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/screen/auth/auth_scaffold.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;

  TextStyle? get _fieldStyle => context.topology.textTheme.bodyMedium
      ?.copyWith(color: context.colors.primary);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    await context.read<AuthenticateProvider>().login(
      context,
      _emailController.text,
      _passwordController.text,
    );
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthLogo(),
          context.vXxl,
          CommonTextField(
            labelText: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            style: _fieldStyle,
            suffixIcon: Icon(Icons.email, color: context.colors.primary),
          ),
          context.vM,
          CommonTextField(
            labelText: 'Password',
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onFieldSubmitted: (_) => _submit(),
            style: _fieldStyle,
            obscureText: true,
            showPasswordToggle: true,
          ),
          context.vL,
          CommonButton(
            text: _isLoading ? 'Logging in...' : 'Login',
            onPressed: _isLoading ? null : _submit,
          ),
          context.vS,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => NavigationService().navigateTo(
                NavigationRoutes.forgotPassword,
              ),
              child: Text('Forgot Password?', style: _fieldStyle),
            ),
          ),
        ],
      ),
    );
  }
}
