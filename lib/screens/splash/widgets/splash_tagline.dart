import 'package:flutter/material.dart';

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
    return Column(
      children: [
        FadeTransition(
          opacity: taglineFade,
          child: SlideTransition(
            position: taglineSlide,
            child: const Text(
              'Jobber City',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black87, // ដាក់ពណ៌ផ្ទាល់សិន
                letterSpacing: -1.0,
                height: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        FadeTransition(
          opacity: subtitleFade,
          child: const Text(
            'Your Career Starts Here',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54, // ដាក់ពណ៌ផ្ទាល់សិន
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
