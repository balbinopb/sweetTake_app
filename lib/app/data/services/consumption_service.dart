import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:sweettake_app/app/constants/api_endpoints.dart';
import 'package:sweettake_app/app/data/models/consumption_model.dart';

import '../../modules/login/controllers/auth_controller.dart';

class ConsumptionService {
  final AuthController authC = Get.find<AuthController>();

  Future<List<dynamic>> fetchConsumptions() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.getAllConsumptions),
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

  static Future<http.Response> submitConsumption({required ConsumptionModel data,required String token}) {
    return http.post(
      Uri.parse(ApiEndpoints.submitConsumption),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data.toJson()),
    );
  }
}
