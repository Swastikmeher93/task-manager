import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:task_manager/widget/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   Future<void>.delayed(const Duration(seconds: 2), () {
  //     if (!mounted) return;
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute<void>(builder: (context) => const HomeView()),
  //     );
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomPaint(
        painter: _SplashBackgroundPainter(),
        child: SizedBox.expand(
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogo(size: 168),
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Task',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: const Color(0xFF3F51B5),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                          ),
                          Text(
                            'Management',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: const Color(0xFF3F51B5),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Simplify your rituals',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color(0xFF757684),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 48,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 120,
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        color: Color(0xFF3F51B5),
                        backgroundColor: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SYNCHRONIZING SANCTUARY',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF757684),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final topLeftBlurPaint = Paint()
      ..color = const Color(0xFFBAC3FF)
      ..style = PaintingStyle.fill
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 80);
    final bottomRightBlurPaint = Paint()
      ..color = const Color(0xFF8FF6D0)
      ..style = PaintingStyle.fill
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 90);

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final topLeftEllipse = Rect.fromCenter(
      center: Offset(size.width * 0.18, size.height * 0.16),
      width: size.width * 0.72,
      height: size.height * 0.24,
    );
    final bottomRightEllipse = Rect.fromCenter(
      center: Offset(size.width * 0.84, size.height * 0.88),
      width: size.width * 0.62,
      height: size.height * 0.22,
    );

    canvas.drawOval(topLeftEllipse, topLeftBlurPaint);
    canvas.drawOval(bottomRightEllipse, bottomRightBlurPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
