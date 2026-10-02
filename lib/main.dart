import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/core/theme/app_theme.dart';
import 'package:inspect/core/utils/pwa_install_helper.dart';
import 'package:inspect/core/utils/web_deep_link_helper.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/agent_provider.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/cycle_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/job_sync_manager_provider.dart';
import 'package:inspect/provider/personnel_provider.dart';
import 'package:inspect/provider/planner_provider.dart';
import 'package:inspect/provider/report_sync_manager_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator().init();
  runApp(MultiProvider(providers: _providers, child: const MyApp()));
}

final List<SingleChildWidget> _providers = [
  ChangeNotifierProvider(create: (_) => AuthenticateProvider()),
  ChangeNotifierProvider(create: (_) => PlannerProvider()),
  ChangeNotifierProvider(create: (_) => CycleProvider()),
  ChangeNotifierProvider(create: (_) => SiteProvider()),
  ChangeNotifierProvider(create: (_) => CustomerProvider()),
  ChangeNotifierProvider(create: (_) => SystemProvider()),
  ChangeNotifierProvider(create: (_) => JobProvider()),
  ChangeNotifierProvider(create: (_) => CategoryProvider()),
  ChangeNotifierProvider(create: (_) => PersonnelProvider()),
  ChangeNotifierProvider(create: (_) => AgentProvider()),
  ChangeNotifierProvider(create: (_) => JobSyncManagerProvider()),
  ChangeNotifierProvider(create: (_) => ReportSyncManagerProvider()),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return MaterialApp(
      title: 'INSPECT - NDT Inspection System',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      navigatorKey: navigationService.navigatorKey,
      onGenerateRoute: navigationService.generateRoute,
      initialRoute: NavigationRoutes.splash,
      navigatorObservers: [RouteObserver()],
      home: const PWALandingScreen(),
    );
  }
}

class PWALandingScreen extends StatefulWidget {
  const PWALandingScreen({super.key});

  @override
  State<PWALandingScreen> createState() => _PWALandingScreenState();
}

class _PWALandingScreenState extends State<PWALandingScreen> {
  bool _isInstalled = false;
  bool _canInstall = false;
  bool _showLanding = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _scheduleEnterApp();
      return;
    }

    _isInstalled = isPwaStandalone();

    if (_isInstalled || WebDeepLinkHandler.isResetPasswordUrl()) {
      _scheduleEnterApp();
      return;
    }

    _showLanding = true;

    listenInstallPrompt(() => setState(() => _canInstall = true));
    listenAppInstalled(() {
      setState(() {
        _isInstalled = true;
        _canInstall = false;
      });
      Future.delayed(const Duration(milliseconds: 500), _enterApp);
    });
  }

  void _scheduleEnterApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _enterApp());
  }

  void _enterApp() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(NavigationRoutes.splash);
  }

  @override
  Widget build(BuildContext context) {
    if (!_showLanding) return const SizedBox.shrink();

    final primary = Theme.of(context).primaryColor;
    const buttonPadding = EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    const buttonText = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primary, primary.withValues(alpha: 0.7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.assessment_outlined,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to INSPECT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'NDT Inspection System - Work anywhere, anytime',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 48),
                  if (_canInstall && !_isInstalled) ...[
                    ElevatedButton.icon(
                      onPressed: triggerInstall,
                      icon: const Icon(Icons.download),
                      label: const Text('Install App'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primary,
                        padding: buttonPadding,
                        textStyle: buttonText,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  OutlinedButton.icon(
                    onPressed: _enterApp,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(_isInstalled ? 'Open App' : 'Continue to App'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: buttonPadding,
                      textStyle: buttonText,
                    ),
                  ),
                  if (!_canInstall && !_isInstalled) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Install option will appear on supported browsers',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}