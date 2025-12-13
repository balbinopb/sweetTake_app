class RegisterModel {
  final String fullname;
  final String phoneNumber;
  final String email;
  final String password;
  final String dateOfBirth;
  final String gender;
  final double weight;
  final double height;
  final String preference;
  final String healthGoal;

  RegisterModel({
    required this.fullname,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    required this.weight,
    required this.height,
    required this.preference,
    required this.healthGoal,
  });

  Map<String, dynamic> toJson(){
    return {
        "fullname": fullname,
        "phone_number": phoneNumber,
        "email": email,
        "password": password,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "weight": weight,
        "height": height,
        "preference": preference,
        "health_goal": healthGoal,
      };
  }
}
