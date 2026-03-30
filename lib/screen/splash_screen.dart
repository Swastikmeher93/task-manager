import 'package:flutter/material.dart';
import 'package:task_manager/screen/home_view.dart';
import 'package:task_manager/services/database_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.wait([
      DatabaseService.instance.database,
      Future<void>.delayed(_splashDuration),
    ]);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => const HomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final width = size.width;
          final height = size.height;
          final isCompact = height < 760;

          return Stack(
            children: [
              Positioned(
                left: -width * 0.12,
                top: -height * 0.06,
                child: _GlowCard(
                  width: width * 0.70,
                  height: height * 0.46,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF7F8FF), Color(0xFFD8DCFF)],
                  ),
                  glowColor: const Color(0xFFBCC5FF),
                ),
              ),
              Positioned(
                right: -width * 0.08,
                bottom: -height * 0.04,
                child: _GlowCard(
                  width: width * 0.58,
                  height: height * 0.41,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE6FFF6), Color(0xFF99F1D3)],
                  ),
                  glowColor: const Color(0xFF87F1D0),
                ),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, isCompact ? -0.18 : -0.14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LogoCluster(size: width * 0.33),
                          SizedBox(height: isCompact ? height * 0.016 : height * 0.024),
                          Text(
                            'Task\nManagement',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineLarge?.copyWith(
                              color: const Color(0xFF3142A1),
                              fontSize: width * 0.095,
                              fontWeight: FontWeight.w800,
                              height: 0.92,
                              letterSpacing: -1.2,
                            ),
                          ),
                          SizedBox(height: height * 0.012),
                          Text(
                            'Simplify your rituals.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF8B8D98),
                              fontSize: width * 0.038,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, isCompact ? 0.52 : 0.58),
                      child: SizedBox(
                        width: width * 0.24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _SplashProgressBar(duration: _splashDuration),
                            SizedBox(height: height * 0.01),
                            Text(
                              'SYNCHRONIZING SANCTUARY',
                              textAlign: TextAlign.center,
                              style: textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF9CA19C),
                                fontSize: width * 0.016,
                                fontWeight: FontWeight.w700,
                                letterSpacing: width * 0.004,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlowCard extends StatelessWidget {
  const _GlowCard({
    required this.width,
    required this.height,
    required this.gradient,
    required this.glowColor,
  });

  final double width;
  final double height;
  final Gradient gradient;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _EllipseGlowPainter(
          gradient: gradient,
          glowColor: glowColor,
        ),
      ),
    );
  }
}

class _EllipseGlowPainter extends CustomPainter {
  const _EllipseGlowPainter({
    required this.gradient,
    required this.glowColor,
  });

  final Gradient gradient;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final oval = Rect.fromCenter(
      center: rect.center,
      width: size.width,
      height: size.height,
    );

    final outerGlowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42);
    canvas.drawOval(oval.inflate(12), outerGlowPaint);

    final innerGlowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.60)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(oval.inflate(4), innerGlowPaint);

    final fillPaint = Paint()..shader = gradient.createShader(oval);
    canvas.drawOval(oval, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _EllipseGlowPainter oldDelegate) {
    return oldDelegate.gradient != gradient || oldDelegate.glowColor != glowColor;
  }
}

class _LogoCluster extends StatelessWidget {
  const _LogoCluster({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3547AF),
                borderRadius: BorderRadius.circular(size * 0.26),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF111A52).withValues(alpha: 0.30),
                    blurRadius: size * 0.22,
                    offset: Offset(0, size * 0.12),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.36,
                  height: size * 0.25,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: size * 0.15,
                          height: size * 0.15,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: size * 0.11,
                          height: size * 0.11,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: size * 0.08,
                          height: size * 0.08,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.05,
            right: -size * 0.09,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: const Color(0xFF7EF0C6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7EF0C6).withValues(alpha: 0.4),
                    blurRadius: size * 0.12,
                  ),
                ],
              ),
              child: Icon(
                Icons.check,
                size: size * 0.12,
                color: const Color(0xFF2B8A67),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashProgressBar extends StatelessWidget {
  const _SplashProgressBar({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        builder: (context, value, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3142A1),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
