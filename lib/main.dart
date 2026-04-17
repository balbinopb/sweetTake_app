import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sweettake_app/app/constants/app_colors.dart';
import 'package:sweettake_app/app/modules/login/controllers/auth_controller.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");
  await GetStorage.init();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SweetTake',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
