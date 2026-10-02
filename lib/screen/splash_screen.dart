import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/core/utils/web_deep_link_handler.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget with RouteAware {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _hasNavigated = false;
  String? _resetToken;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    // 🔥 EXTRACT TOKEN IMMEDIATELY IN initState (before any async operations)
    if (kIsWeb) {
      _resetToken = WebDeepLinkHandler.getResetPasswordToken();
      if (_resetToken != null) {
        debugPrint('🔑 Reset token extracted in initState: ${_resetToken!.substring(0, 10)}...');
      }
    }

    Timer(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });

    // 🔥 SAFETY TIMEOUT: Force navigation after 10 seconds if stuck
    Timer(const Duration(seconds: 10), () {
      if (!_hasNavigated && mounted) {
        debugPrint('⚠️ TIMEOUT: Splash screen stuck, forcing navigation');
        if (_resetToken != null) {
          _navigateToResetPassword(_resetToken!);
        } else {
          _navigateToLogin();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // 🔥 ALSO CHECK FOR MOBILE DEEP LINK TOKEN FROM ROUTE ARGUMENTS
    if (_resetToken == null) {
      try {
        final route = ModalRoute.of(context);
        final args = route?.settings.arguments;
        
        if (args is Map<String, dynamic> && args.containsKey('resetToken')) {
          _resetToken = args['resetToken'] as String?;
          if (_resetToken != null) {
            debugPrint('🔑 Reset token from route args: ${_resetToken!.substring(0, 10)}...');
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error getting route arguments: $e');
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    if (_hasNavigated) return;

    try {
      debugPrint('🚀 Checking login status from splash...');
      
      // 🔥 PRIORITY 1: Check for reset password token FIRST
      if (_resetToken != null && _resetToken!.isNotEmpty) {
        debugPrint('🔑 Reset password token detected, navigating to reset screen');
        _navigateToResetPassword(_resetToken!);
        return; // Exit early - don't check login
      }

      // 🔥 PRIORITY 2: No reset token, proceed with normal login verification
      final provider = context.read<AuthenticateProvider>();

      // Add timeout to verifyToken call
      await provider.verifyToken(context).timeout(
        const Duration(seconds: 7),
        onTimeout: () {
          debugPrint('⏰ Token verification timed out, navigating to login');
          if (!_hasNavigated && mounted) {
            _navigateToLogin();
          }
        },
      );

      debugPrint('✅ Login check completed');
    } catch (e) {
      debugPrint('❌ Login check error: $e');
      if (!_hasNavigated && mounted) {
        // If there's a reset token despite the error, use it
        if (_resetToken != null && _resetToken!.isNotEmpty) {
          _navigateToResetPassword(_resetToken!);
        } else {
          _navigateToLogin();
        }
      }
    }
  }

  void _navigateToResetPassword(String token) {
    if (_hasNavigated) return;

    _hasNavigated = true;
    if (mounted) {
      debugPrint('➡️ Navigating to reset password screen with token');
      
      // Clean the URL if on web
      if (kIsWeb) {
        WebDeepLinkHandler.clearUrlParameters();
      }
      
      Navigator.of(context).pushReplacementNamed(
        NavigationRoutes.resetPassword,
        arguments: {'token': token},
      );
    }
  }

  void _navigateToLogin() {
    if (_hasNavigated) return;

    _hasNavigated = true;
    if (mounted) {
      debugPrint('➡️ Navigating to login screen');
      Navigator.of(context).pushReplacementNamed(NavigationRoutes.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            // 🔄 Logo animation
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
            
            // 🔥 DEBUG INFO (remove in production)
            if (kIsWeb && _resetToken != null)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Reset token detected: ${_resetToken!.substring(0, 10)}...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}