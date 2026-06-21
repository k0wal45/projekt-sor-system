class EnvConstants {
  static const String apiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://100.114.242.128:8080/api/',
  );
}
