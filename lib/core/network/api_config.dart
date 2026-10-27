class ApiConfig {
  static const String baseUrl = 'https://pitaya-pro.onrender.com';

  /// Render free tier can sleep — first call may take ~60s
  static const Duration timeout = Duration(seconds: 90);
}