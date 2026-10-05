import 'package:flutter/material.dart';

import 'navigation_route.dart';

enum NavTransition { none, fade, slideRight, slideUp, scale }

class NavigationService {
  NavigationService._internal();

  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<String> _navigationHistory = [];
  final Map<String, WidgetBuilder> _routes = {};

  // ...rest of the class unchanged

  MapEntry<String, Object?> Function(Uri uri)? _deepLinkResolver;

  late final NavigatorObserver observer = _NavigationHistoryObserver(
    _navigationHistory,
  );

  void registerDeepLinkResolver(
    MapEntry<String, Object?> Function(Uri uri) resolver,
  ) {
    _deepLinkResolver = resolver;
  }

  void registerRoutes(Map<String, WidgetBuilder> routes) {
    _routes.addAll(routes);
  }

  String? get currentRoute =>
      _navigationHistory.isNotEmpty ? _navigationHistory.last : null;

  List<String> get navigationHistory => List.unmodifiable(_navigationHistory);

  PageRoute<T> _buildRoute<T>(
    String routeName, {
    Object? arguments,
    NavTransition transition = NavTransition.slideRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    // Dynamically registered routes (via registerRoutes) win over the
    // static table in NavigationRoutes; unknown names fall through to
    // RouteNotFoundScreen inside NavigationRoutes.getBuilder.
    final builder =
        _routes[routeName] ?? NavigationRoutes.getBuilder(routeName, arguments);

    if (transition == NavTransition.none) {
      return MaterialPageRoute<T>(
        settings: RouteSettings(name: routeName, arguments: arguments),
        builder: builder,
      );
    }

    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transition) {
          case NavTransition.fade:
            return FadeTransition(opacity: animation, child: child);
          case NavTransition.slideUp:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          case NavTransition.scale:
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: FadeTransition(opacity: animation, child: child),
            );
          case NavTransition.slideRight:
          default:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
        }
      },
    );
  }

  /// Pass directly as `MaterialApp(onGenerateRoute: locator<NavigationService>().generateRoute)`.
  /// Builds every route with [NavTransition.none] since `MaterialApp`
  /// applies its own default platform transition here; use
  /// [navigateTo]/[replaceTo]/etc. for custom transitions on top of that.
  Route<dynamic> generateRoute(RouteSettings settings) {
    return _buildRoute<dynamic>(
      settings.name ?? NavigationRoutes.splash,
      arguments: settings.arguments,
      transition: NavTransition.none,
    );
  }

  Future<dynamic> navigateTo(
    String routeName, {
    Object? arguments,
    NavTransition transition = NavTransition.slideRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return navigatorKey.currentState!.push(
      _buildRoute(
        routeName,
        arguments: arguments,
        transition: transition,
        duration: duration,
      ),
    );
  }

  Future<dynamic> replaceTo(
    String routeName, {
    Object? arguments,
    NavTransition transition = NavTransition.slideRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return navigatorKey.currentState!.pushReplacement(
      _buildRoute(
        routeName,
        arguments: arguments,
        transition: transition,
        duration: duration,
      ),
    );
  }

  Future<dynamic> navigateToAndRemoveUntil(
    String routeName, {
    Object? arguments,
    NavTransition transition = NavTransition.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    debugPrint('REMOVE-UNTIL $routeName\n${StackTrace.current}');
    return navigatorKey.currentState!.pushAndRemoveUntil(
      _buildRoute(
        routeName,
        arguments: arguments,
        transition: transition,
        duration: duration,
      ),
      (route) => false,
    );
  }

  Future<dynamic> navigateToAndRemoveUntilRoute(
    String routeName,
    String untilRouteName, {
    Object? arguments,
    NavTransition transition = NavTransition.slideRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      _buildRoute(
        routeName,
        arguments: arguments,
        transition: transition,
        duration: duration,
      ),
      ModalRoute.withName(untilRouteName),
    );
  }

  // Future<bool> navigateToExternal(
  //     String url, {
  //       LaunchMode mode = LaunchMode.externalApplication,
  //     }) async {
  //   final uri = Uri.parse(url);
  //   return await canLaunchUrl(uri) ? await launchUrl(uri, mode: mode) : false;
  // }

  Future<dynamic> handleDeepLink(
    Uri uri, {
    bool override = false,
    NavTransition transition = NavTransition.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final resolved =
        _deepLinkResolver?.call(uri) ??
        MapEntry(uri.path.isEmpty ? '/' : uri.path, uri.queryParameters);

    var routeName = resolved.key;
    if (routeName.length > 1 && routeName.endsWith('/')) {
      routeName = routeName.substring(0, routeName.length - 1);
    }

    return override
        ? navigateToAndRemoveUntil(
            routeName,
            arguments: resolved.value,
            transition: transition,
            duration: duration,
          )
        : navigateTo(
            routeName,
            arguments: resolved.value,
            transition: transition,
            duration: duration,
          );
  }

  void goBack() {
    debugPrint('before pop: $_navigationHistory');
    navigatorKey.currentState!.pop();
  }

  void goBackWithResult(dynamic result) =>
      navigatorKey.currentState!.pop(result);

  bool canGoBack() => navigatorKey.currentState!.canPop();

  void goBackToRoute(String routeName) =>
      navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
}

class _NavigationHistoryObserver extends NavigatorObserver {
  final List<String> history;

  _NavigationHistoryObserver(this.history);

  String? _nameOf(Route<dynamic> route) =>
      route is PageRoute ? route.settings.name : null;

  void _remove(Route<dynamic> route) {
    final name = _nameOf(route);
    if (name == null) return;
    final i = history.lastIndexOf(name);
    if (i != -1) history.removeAt(i);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
      'PUSH ${route.settings.name} (${route.runtimeType}) over ${previousRoute?.settings.name}',
    );
    if (route.settings.name != null) history.add(route.settings.name!);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('POP ${route.settings.name} (${route.runtimeType})');
    if (history.isNotEmpty) history.removeLast();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('REMOVE ${route.settings.name}');
    if (route.settings.name != null) history.remove(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
      'REPLACE ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
    );
    if (oldRoute?.settings.name != null)
      history.remove(oldRoute!.settings.name);
    if (newRoute?.settings.name != null) history.add(newRoute!.settings.name!);
  }
}
