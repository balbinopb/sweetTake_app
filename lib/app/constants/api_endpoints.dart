import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl {
    final host = dotenv.env["API_HOST"] ?? (throw Exception("API_HOST not defined"));

    final version = dotenv.env["API_VERSION"] ?? "/v1/api";
    // final version = "/v1/api";

    // return "$host$version";
    return "$host$version";
  }



  // Auth
  static String get register => "$baseUrl/register";
  static String get login => "$baseUrl/login";
  static String get forgotPassword => "$baseUrl/forgot-password";
  static String get resetPassword => "$baseUrl/reset-password";

  // Protected endpoints
  static const String _auth = "/auth";
  static String get profile => "$baseUrl$_auth/profile";
  static String get submitConsumption => "$baseUrl$_auth/consumption";
  static String get getAllConsumptions => "$baseUrl$_auth/consumptions";
  static String get submitBloodSugar => "$baseUrl$_auth/bloodsugar";
  static String get getAllBloodSugars => "$baseUrl$_auth/bloodsugars";
}
