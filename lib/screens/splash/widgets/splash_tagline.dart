import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 🟢 Added Get for Translations

class SplashTagline extends StatelessWidget {
  final Animation<double> taglineFade;
  final Animation<Offset> taglineSlide;
  final Animation<double> subtitleFade;

  const SplashTagline({
    super.key,
    required this.taglineFade,
    required this.taglineSlide,
    required this.subtitleFade,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // 🟢 Theme Check

    return Column(
      children: [
        FadeTransition(
          opacity: taglineFade,
          child: SlideTransition(
            position: taglineSlide,
            child: Text(
              'Jobber City', // 🟢 Usually Brand Names remain untranslated, but styles updated
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Title
                letterSpacing: -1.0,
                height: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        FadeTransition(
          opacity: subtitleFade,
          child: Text(
            'Your Career Starts Here'.tr, // 🟢 Added .tr
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? Colors.white70
                  : Colors.black54, // 🟢 Dynamic Subtitle
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
