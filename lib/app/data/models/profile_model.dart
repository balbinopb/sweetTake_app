class ProfileModel {
  final String fullname;
  final String email;
  final String? gender;
  final String? dateOfBirth;
  final double? height;
  final double? weight;
  final String? contactInfo;
  final String? healthGoal;
  final String? preference;

  ProfileModel({
    required this.fullname,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.contactInfo,
    this.healthGoal,
    this.preference,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullname: json['fullname'] ?? '-',
      email: json['email'] ?? '-',
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      height: (json['height'] != null) ? json['height'].toDouble() : null,
      weight: (json['weight'] != null) ? json['weight'].toDouble() : null,
      contactInfo: json['phone_number'],
      healthGoal: json['health_goal'],
      preference: json['preference'],
    );
  }
}
