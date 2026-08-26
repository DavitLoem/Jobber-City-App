import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations

class SplashLoader extends StatelessWidget {
  final Animation<double> loaderFade;
  final Animation<double> loaderProgress;

  const SplashLoader({
    super.key,
    required this.loaderFade,
    required this.loaderProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return FadeTransition(
      opacity: loaderFade,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFEEEEEE), // 🟢 Dynamic Loader Track
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedBuilder(
                animation: loaderProgress,
                builder: (_, _) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: loaderProgress.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E5BFF), Color(0xFF5B7FFF)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2E5BFF,
                            ).withValues(alpha: 0.50),
                            blurRadius: 6,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: loaderProgress,
              builder: (_, _) {
                final progress = loaderProgress.value;
                final status = progress < 0.4
                    ? 'Loading…'
                          .tr // 🟢 Added .tr
                    : progress < 0.75
                    ? 'Getting things ready…'
                          .tr // 🟢 Added .tr
                    : 'Almost there…'.tr; // 🟢 Added .tr
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    status,
                    key: ValueKey(status),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white70
                          : Colors.black54, // 🟢 Dynamic Text
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
