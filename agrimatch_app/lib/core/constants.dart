class API {
  static const String base =
      "http://10.39.193.21:7000"; // emulator -> host machine
  static String get register => "$base/api/auth/register";
  static String get login => "$base/api/auth/login";
  static String get analyzeSoil => "$base/api/soil/analyze";
  static String get history => "$base/api/soil/history";
  static String get chat => "$base/api/chat";
  static String get me => "$base/api/auth/me";
  static String get update => "$base/api/auth/update";
}
