import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // 🟢 Included AppColors for dark mode integration
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class CvPdfView extends StatelessWidget {
  final String pdfUrl;
  const CvPdfView({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 🟢 Theme Check
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic BG
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, // 🟢 Dynamic AppBar BG
        elevation: 1,
        title: Text(
          'My CV'.tr, // 🟢 Added .tr
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Title
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.open_in_new_rounded,
              color: theme.textTheme.bodyLarge?.color, // 🟢 Dynamic Icon
            ),
            tooltip: 'Open in browser / download'.tr, // 🟢 Added .tr
            onPressed: () => launchUrl(
              Uri.parse(pdfUrl),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          Get.snackbar(
            'Cannot Load CV'.tr, // 🟢 Added .tr
            details.error,
            backgroundColor: isDark
                ? AppColors.error.withValues(alpha: 0.15)
                : Colors.red.shade50, // 🟢 Dynamic BG
            colorText: isDark
                ? Colors.redAccent
                : Colors.red.shade700, // 🟢 Dynamic Text
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
    );
  }
}
