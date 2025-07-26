class EnvConfig {
  // Replace this with your actual Pexels API key
  // You can get a free API key from: https://www.pexels.com/api/
  static const String pexelsApiKey = 'your-actual-api-key-here';

  // API endpoints
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1/';

  // API limits
  static const int defaultPageSize = 20;
  static const int maxPageSize = 80;

  // Cache settings
  static const Duration imageCacheDuration = Duration(days: 7);
  static const Duration dataCacheDuration = Duration(hours: 24);
}
