/// Application-wide constants
class AppConstants {
  AppConstants._();

  // API & Endpoints
  static const String firebaseProjectId = 'safe-city-redemption';

  // App Info
  static const String appName = 'SafeCity';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Pagination
  static const int pageSize = 20;
  static const int initialPageSize = 10;

  // Map defaults
  static const double defaultMapZoom = 15.0;
  static const double initialMapZoom = 13.0;

  // Locations (Redemption City, Nigeria)
  static const double redemptionCityLat = 6.5244;
  static const double redemptionCityLng = 3.3792;
}
