// Stub for non-web platforms (Android, iOS, desktop)
class WebDeepLinkHandler {
  static Map<String, String> getQueryParameters() => {};

  static bool isResetPasswordUrl() => false;

  static String? getResetPasswordToken() => null;

  static void listenToUrlChanges(Function(String) onUrlChange) {}

  static void clearUrlParameters() {}

  static String getCurrentRoutePath() => '/';

  static bool isRoute(String routeName) => false;

  static void debugPrintUrl() {}
}
