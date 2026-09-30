import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final background = Image.asset(
      'assets/images/bg.png',
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.bottomCenter,
    );

    if (context.isTablet) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            background,
            Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width / 3,
                padding: context.paddingAll,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(child: child),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: background),
            Center(
              child: SingleChildScrollView(
                padding: context.paddingAll,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.jpg',
      fit: BoxFit.contain,
      width: MediaQuery.sizeOf(context).width * 0.5,
    );
  }
}
