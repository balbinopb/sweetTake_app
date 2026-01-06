

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthController extends GetxController {
  final _box = GetStorage();
  final token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // token.value = _box.read('token') ?? '';
    _loadToken();
  }

  
  void _loadToken() {
    final savedToken = _box.read('token');

    if (savedToken == null || savedToken.isEmpty) {
      token.value = '';
      return;
    }

    if (JwtDecoder.isExpired(savedToken)) {
      logout();
      return;
    }

    token.value = savedToken;
  }

  void setToken(String newToken) {
    token.value = newToken;
    _box.write('token', newToken);
  }

  void logout() {
    token.value = '';
    _box.remove('token');
  }

  bool get isLoggedIn => token.value.isNotEmpty;
}

