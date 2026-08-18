import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CvViewerView extends StatelessWidget {
  final String pdfUrl;
  final String candidateName;

  const CvViewerView({
    super.key,
    required this.pdfUrl,
    required this.candidateName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 1,
        title: Text(
          "@name's CV".trParams({'name': candidateName}), // 🟢 Added .trParams
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          Get.snackbar(
            "Cannot Load CV".tr, // 🟢 Added .tr
            details.error,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
    );
  }
}
