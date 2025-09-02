class ApiConfig {
  // Update this to your machine's LAN IP when running on device/emulator
  // Example: 10.0.2.2 for Android emulator, 127.0.0.1 for web, or your Wi-Fi IP
  static const String _host = '10.0.2.2';
  static const int _port = 8000;

  static String get baseUrl => 'http://$_host:$_port/api/v1';
}


