import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/constants/api_endpoints.dart';
import 'package:sweettake_app/app/data/models/login_model.dart';
import 'package:sweettake_app/app/data/models/register_model.dart';

class AuthService {

  // Send registration request to the backend with user data
  static Future<http.Response> register(RegisterModel data) {
    return http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data.toJson()),
    );
  }
  
  // Send login request to the backend with user credentials
  static Future<http.Response> login(LoginModel data) {
    return http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data.toJson()),
    );
  }

}
