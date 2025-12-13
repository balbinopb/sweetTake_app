

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final _box = GetStorage();
  final token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = _box.read('token') ?? '';
  }

  void setToken(String newToken) {
    token.value = newToken;
    _box.write('token', newToken);
  }

  void logout() {
    token.value = '';
    _box.remove('token');
  }
}

