import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

class BannerData {
  const BannerData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final List<Color> colors;
}

const promoBannersList = [
  BannerData(
    title: "Find Your Dream\nCareer",
    subtitle: "Explore thousands of verified companies hiring today.",
    buttonText: "Explore Jobs",
    colors: [AppColors.primary, AppColors.secondary],
  ),
  BannerData(
    title: "Build A Standout\nResume",
    subtitle: "Get noticed by recruiters with a polished, ATS-ready CV.",
    buttonText: "Build Resume",
    colors: [AppColors.primaryDark, AppColors.primary],
  ),
  BannerData(
    title: "Track Every\nApplication",
    subtitle: "Stay on top of interviews and offers, all in one place.",
    buttonText: "View Progress",
    colors: [AppColors.secondary, AppColors.accent],
  ),
];

class PromoBannerSlider extends StatefulWidget {
  const PromoBannerSlider({super.key});

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  static const int _initialPage = 5000;

  late final PageController _pageController = PageController(
    viewportFraction: 1,
    initialPage: _initialPage,
  );
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next =
          (_pageController.page ?? _initialPage.toDouble()).round() + 1;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        SizedBox(
          height: 192,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() => _currentIndex = page % promoBannersList.length);
            },
            itemBuilder: (context, page) {
              final banner = promoBannersList[page % promoBannersList.length];
              return _buildBannerCard(banner);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(promoBannersList.length, (i) {
            final isActive = i == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.pageIndicatorActive
                    : AppColors.pageIndicatorInactive,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BannerData banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.colors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: banner.colors.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            top: -18,
            child: _decorCircle(70, Colors.white.withValues(alpha: 0.10)),
          ),
          Positioned(
            right: 30,
            top: 6,
            child: _decorCircle(22, Colors.white.withValues(alpha: 0.16)),
          ),
          Positioned(
            right: 4,
            bottom: -14,
            child: _decorCircle(40, Colors.white.withValues(alpha: 0.12)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 190,
                child: Text(
                  banner.subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      banner.buttonText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: banner.colors.first,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: banner.colors.first,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
