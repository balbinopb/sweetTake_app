import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_endpoints.dart';
import '../../modules/login/controllers/auth_controller.dart';

class HistoryService {
  final AuthController _authC = Get.find<AuthController>();

  Future<List<dynamic>> bloodSugar() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllBloodSugars),
      headers: {'Authorization': 'Bearer ${_authC.token.value}'},
    );

    final Map<String, dynamic> body = jsonDecode(response.body);

    return body['data'];
  }

  Future<List<dynamic>> sugarConsumption() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllConsumptions),
      headers: {
        'Authorization': 'Bearer ${_authC.token.value}',
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    return body['data'];
  }

  // delete sugar consumption
  Future<void> deleteSugar(int id) async {
    final response = await http.delete(
      Uri.parse(ApiEndpoints.deleteConsumption(id)),
      headers: {'Authorization': 'Bearer ${_authC.token.value}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete consumption');
    }
  }

  // delete blood sugar
  Future<void> deleteBloodSugar(int id) async {
    final response = await http.delete(
      Uri.parse(ApiEndpoints.deleteBloodSugar(id)),
      headers: {'Authorization': 'Bearer ${_authC.token.value}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete blood sugar');
    }
  }

  // update sugar consumption
  Future<void> updateSugarConsumption(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.updateConsumption(id)),
      headers: {
        'Authorization': 'Bearer ${_authC.token.value}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sugar consumption');
    }
  }

  // update blood sugar
  Future<void> updateBloodSugar(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse(ApiEndpoints.updateBloodSugar(id)),
      headers: {
        'Authorization': 'Bearer ${_authC.token.value}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update blood sugar');
    }
  }
}
