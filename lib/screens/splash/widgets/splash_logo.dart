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
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

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
                          color: const Color(0xFF2E5BFF).withValues(
                            alpha: isDark ? 0.35 : 0.20,
                          ), // 🟢 Dynamic Glow
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
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF2A2D3E), const Color(0xFF1E1F2A)]
                          : [
                              const Color.fromARGB(255, 232, 233, 236),
                              const Color.fromARGB(255, 255, 255, 255),
                            ], // 🟢 Dynamic App Icon Box BG
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E5BFF).withValues(
                          alpha: isDark ? 0.25 : 0.40,
                        ), // 🟢 Dynamic App Icon Box Shadow
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Image.asset(
                      "assets/logos/jbc.png",
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
                                Colors.white.withValues(
                                  alpha: isDark ? 0.08 : 0.18,
                                ), // 🟢 Less intense shimmer in dark mode to prevent washing out
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
