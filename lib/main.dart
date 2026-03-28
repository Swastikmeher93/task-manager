import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/screen/home_view.dart';
import 'package:task_manager/services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData.light().textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
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
      home: const HomeView(),
    );
  }
}
