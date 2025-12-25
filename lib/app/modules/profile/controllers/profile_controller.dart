import 'package:get/get.dart';

import '../../../data/models/profile_model.dart';

class ProfileController extends GetxController {
  final profile = Rxn<ProfileModel>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Simulate API fetch delay
      await Future.delayed(const Duration(seconds: 1));

      // API parsing
      final data = {
        "date_of_birth": "2000-01-12T07:00:00+07:00",
        "email": "test@gmail.com",
        "fullname": "Balbino Pedro",
        "gender": "Male",
        "health_goal": "Reduce sugar intake",
        "height": 171.5,
        "phone_number": "880154221555",
        "preference": "Diabetic-Friendly Diet",
        "user_id": 1,
        "weight": 66,
      };

      profile.value = ProfileModel.fromJson(data);
    } catch (e) {
      errorMessage.value = "Failed to load profile.";
    } finally {
      isLoading.value = false;
    }
  }

  void refreshProfile() {
    fetchProfile();
  }
}
