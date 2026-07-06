import 'package:flutter/material.dart';
import 'package:jobber_city/screens/role/seeker/location_screen/colors/location_colors.dart';

class LocationHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;
  final bool showBackButton;

  const LocationHeader({
    super.key,
    required this.title,
    required this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBackPressed,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: LocationColors.ink,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              _buildLocationLogo(),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: LocationColors.ink,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Select your province to find jobs near you',
            style: TextStyle(
              fontSize: 14,
              color: LocationColors.sub,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [LocationColors.accent, LocationColors.accentLt],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: LocationColors.accent.withValues(alpha: 0.30),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(
        Icons.location_city_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
