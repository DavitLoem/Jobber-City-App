import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/utils/token_storage.dart';
import 'package:jobber_city/routes/app_routes.dart';

import 'widgets/splash_background.dart';
import 'widgets/splash_loader.dart';
import 'widgets/splash_logo.dart';
import 'widgets/splash_tagline.dart';

part 'splash_binding.dart';
part 'splash_controller.dart';

class SplashView extends GetView<SplashViewController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ប្រើប្រាស់ 'controller' ដើម្បីបោះតម្លៃ Animation ទៅឱ្យ Widgets
          SplashBackground(
            size: size,
            bgCtrl: controller.bgCtrl,
            blob1Pos: controller.blob1Pos,
            blob1Scale: controller.blob1Scale,
            blob2Pos: controller.blob2Pos,
            blob2Scale: controller.blob2Scale,
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                SplashLogo(
                  logoCtrl: controller.logoCtrl,
                  logoFade: controller.logoFade,
                  logoScale: controller.logoScale,
                  glowOpacity: controller.glowOpacity,
                  shimmer: controller.shimmer,
                ),
                const Spacer(flex: 2),
                SplashTagline(
                  taglineFade: controller.taglineFade,
                  taglineSlide: controller.taglineSlide,
                  subtitleFade: controller.subtitleFade,
                ),
                const Spacer(flex: 4),
                SplashLoader(
                  loaderFade: controller.loaderFade,
                  loaderProgress: controller.loaderProgress,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
