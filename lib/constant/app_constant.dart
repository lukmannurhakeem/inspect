class AppConstants {
  AppConstants._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.inspectplatform.com/api/v1',
  );

  static const String muslimApiBaseUrl = String.fromEnvironment(
    'MUSLIM_API_BASE_URL',
    defaultValue: 'https://api.waktusolat.app/',
  );
}
