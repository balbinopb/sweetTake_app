import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../modules/login/controllers/auth_controller.dart';

class ConsumptionService {
  final AuthController authC = Get.find<AuthController>();

  final baseUrl='http://10.0.2.2:8080/v1/api/auth';

  Future<List<dynamic>> fetchConsumptions() async {
    final response = await http.get(
      Uri.parse("$baseUrl/consumptions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${authC.token.value}",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final body = jsonDecode(response.body);

    return body['data'];
  }
}
