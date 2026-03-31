import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/screen/splash_screen.dart';
import 'package:task_manager/services/home_ui_controller.dart';
import 'package:task_manager/services/task_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData.light().textTheme;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<TaskController>(() => TaskController(), fenix: true);
        Get.lazyPut<HomeUiController>(() => HomeUiController(), fenix: true);
      }),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBAC3FF)),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.interTextTheme(baseTextTheme).copyWith(
          displayLarge: GoogleFonts.manrope(
            textStyle: baseTextTheme.displayLarge,
          ),
          displayMedium: GoogleFonts.manrope(
            textStyle: baseTextTheme.displayMedium,
          ),
          displaySmall: GoogleFonts.manrope(
            textStyle: baseTextTheme.displaySmall,
          ),
          headlineLarge: GoogleFonts.manrope(
            textStyle: baseTextTheme.headlineLarge,
          ),
          headlineMedium: GoogleFonts.manrope(
            textStyle: baseTextTheme.headlineMedium,
          ),
          headlineSmall: GoogleFonts.manrope(
            textStyle: baseTextTheme.headlineSmall,
          ),
          titleLarge: GoogleFonts.manrope(textStyle: baseTextTheme.titleLarge),
          titleMedium: GoogleFonts.manrope(
            textStyle: baseTextTheme.titleMedium,
          ),
          titleSmall: GoogleFonts.manrope(textStyle: baseTextTheme.titleSmall),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
