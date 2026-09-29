class AppConstants {
  AppConstants._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.169.0.148:8082/api/',
  );

  static const String muslimApiBaseUrl = String.fromEnvironment(
    'MUSLIM_API_BASE_URL',
    defaultValue: 'https://api.waktusolat.app/',
  );
}
