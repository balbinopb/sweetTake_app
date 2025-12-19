import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../modules/login/controllers/auth_controller.dart';

class ConsumptionService {
  final AuthController authC = Get.find<AuthController>();

  Future<List<dynamic>> fetchConsumptions() async {
    final response = await http.get(
      Uri.parse("${dotenv.get('BASE_URL_AUTH')}/consumptions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${authC.token.value}",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final body = jsonDecode(response.body);

    return body['data']; // must match backend
  }
}
