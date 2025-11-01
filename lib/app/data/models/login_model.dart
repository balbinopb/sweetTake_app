


class LoginModel {
  late final String email;
  late final String password;

  LoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
