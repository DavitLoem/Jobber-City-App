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
                      const Color(
                        0xFF2E5BFF,
                      ).withValues(alpha: 0.12), // ប្រើតម្លៃ Light Mode
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
                      const Color(
                        0xFF5B7FFF,
                      ).withValues(alpha: 0.10), // ប្រើតម្លៃ Light Mode
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
            opacity: 0.025, // ប្រើតម្លៃ Light Mode
            child: CustomPaint(painter: DotGridPainter()),
          ),
        ),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    const radius = 1.5;
    final paint = Paint()..color = const Color(0xFF2E5BFF);

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
