import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/seeker/cv_generator_model.dart';

class CvTemplateCard extends StatelessWidget {
  final CvTemplateModel template;
  final bool isSelected;
  final VoidCallback onTap;
  const CvTemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder.withValues(alpha: 0.6),
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple layout thumbnail — mimics each template's structure
            // (sidebar / single-column / header-band) without needing a
            // real rendered preview image for every template.
            _Thumbnail(templateId: template.id, isSelected: isSelected),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.description,
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String templateId;
  final bool isSelected;
  const _Thumbnail({required this.templateId, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final accent = isSelected ? AppColors.primary : Colors.grey.shade400;
    return Container(
      width: 44,
      height: 58,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: templateId == 'modern'
          ? Row(
              children: [
                Container(width: 12, color: accent.withValues(alpha: 0.35)),
                const SizedBox(width: 3),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(4, (_) => _line(accent)),
                  ),
                ),
              ],
            )
          : templateId == 'elegant'
              ? Column(
                  children: [
                    Container(height: 10, width: double.infinity, color: accent.withValues(alpha: 0.45)),
                    const SizedBox(height: 4),
                    ...List.generate(3, (_) => _line(accent)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (_) => _line(accent)),
                ),
    );
  }

  Widget _line(Color color) => Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        height: 2.5,
        width: double.infinity,
        color: color.withValues(alpha: 0.3),
      );
}
