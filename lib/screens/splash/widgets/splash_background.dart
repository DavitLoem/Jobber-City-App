import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final Size size;
  final AnimationController bgCtrl;
  final Animation<double> blob1Scale;
  final Animation<double> blob2Scale;
  final Animation<Offset> blob1Pos;
  final Animation<Offset> blob2Pos;

  const SplashBackground({
    super.key,
    required this.size,
    required this.bgCtrl,
    required this.blob1Scale,
    required this.blob2Scale,
    required this.blob1Pos,
    required this.blob2Pos,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Stack(
      children: [
        AnimatedBuilder(
          animation: bgCtrl,
          builder: (_, _) => Positioned(
            top: -size.width * 0.25 + blob1Pos.value.dy * 60,
            right: -size.width * 0.20 + blob1Pos.value.dx * 60,
            child: Transform.scale(
              scale: blob1Scale.value,
              child: Container(
                width: size.width * 0.70,
                height: size.width * 0.70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF2E5BFF).withValues(
                        alpha: isDark ? 0.25 : 0.12,
                      ), // 🟢 Dynamic Blob Intensity
                      const Color(0xFF2E5BFF).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: bgCtrl,
          builder: (_, _) => Positioned(
            bottom: -size.width * 0.20 + blob2Pos.value.dy * 50,
            left: -size.width * 0.25 + blob2Pos.value.dx * 50,
            child: Transform.scale(
              scale: blob2Scale.value,
              child: Container(
                width: size.width * 0.65,
                height: size.width * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF5B7FFF).withValues(
                        alpha: isDark ? 0.20 : 0.10,
                      ), // 🟢 Dynamic Blob Intensity
                      const Color(0xFF5B7FFF).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: isDark
                ? 0.05
                : 0.025, // 🟢 Enhance dot visibility slightly on dark backgrounds
            child: CustomPaint(painter: DotGridPainter(isDark: isDark)),
          ),
        ),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  final bool isDark; // 🟢 Injected Theme Status
  DotGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    const radius = 1.5;
    final paint = Paint()
      ..color = isDark
          ? Colors.white
          : const Color(0xFF2E5BFF); // 🟢 Dynamic Dot Color

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
