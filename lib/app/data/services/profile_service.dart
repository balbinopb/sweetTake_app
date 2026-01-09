
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sweettake_app/app/constants/api_endpoints.dart';
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';

class ProfileService {

  final _authC = Get.find<AuthController>();
  
  Future<http.Response> fetchProfile() async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.profile),
      headers: {
        'Authorization': "Bearer ${_authC.token.value}",
        'Content-Type': 'application/json',
      },
    );

    return response;
  }
}
