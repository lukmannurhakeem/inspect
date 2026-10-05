import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/core/utils/web_deep_link_handler.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  Timer? _timer;
  bool _hasNavigated = false;
  String? _resetToken;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    // Read the web deep-link token before any async work.
    if (kIsWeb) {
      _resetToken = WebDeepLinkHandler.getResetPasswordToken();
    }

    _timer = Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Mobile deep link token passed via route arguments.
    if (_resetToken == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _resetToken = args['resetToken'] as String?;
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    if (_hasNavigated || !mounted) return;

    final token = _resetToken;
    if (token != null && token.isNotEmpty) {
      _navigateToResetPassword(token);
      return;
    }

    try {
      await context
          .read<AuthenticateProvider>()
          .verifyToken(context)
          .timeout(const Duration(seconds: 7), onTimeout: _navigateToLogin);
    } catch (e) {
      debugPrint('Login check error: $e');
      _navigateToLogin();
    }
  }

  void _navigateToResetPassword(String token) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    if (kIsWeb) WebDeepLinkHandler.clearUrlParameters();

    Navigator.of(context).pushReplacementNamed(
      NavigationRoutes.resetPassword,
      arguments: {'token': token},
    );
  }

  void _navigateToLogin() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    Navigator.of(context).pushReplacementNamed(NavigationRoutes.login);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: FadeTransition(
                  opacity: _animation,
                  child: ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/images/bg.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}