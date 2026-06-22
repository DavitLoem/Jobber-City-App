import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final AnimationController logoCtrl;
  final Animation<double> logoFade;
  final Animation<double> logoScale;
  final Animation<double> glowOpacity;
  final Animation<double> shimmer;

  const SplashLogo({
    super.key,
    required this.logoCtrl,
    required this.logoFade,
    required this.logoScale,
    required this.glowOpacity,
    required this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: logoCtrl,
      builder: (_, child) {
        return FadeTransition(
          opacity: logoFade,
          child: Transform.scale(
            scale: logoScale.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: glowOpacity.value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF2E5BFF,
                          ).withValues(alpha: 0.20),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 232, 233, 236),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E5BFF).withValues(alpha: 0.40),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: AnimatedBuilder(
                      animation: shimmer,
                      builder: (_, _) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            final sweep = shimmer.value;
                            return LinearGradient(
                              begin: Alignment(-1.5 + sweep * 3.5, -0.5),
                              end: Alignment(-0.5 + sweep * 3.5, 0.5),
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.18),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Container(color: Colors.transparent),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
