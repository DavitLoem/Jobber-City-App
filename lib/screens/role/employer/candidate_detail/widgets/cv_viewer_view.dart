import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "$candidateName's CV",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      // 🎯 ប្រើប្រាស់ SfPdfViewer ដើម្បីទាញ និងបង្ហាញ PDF ពី Internet
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        // 🎯 បន្ថែមមុខងារចាប់ Error នេះ
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          // បង្ហាញសារប្រាប់ User ពេលបើកមិនចេញ
          Get.snackbar(
            "Cannot Load CV",
            details.error,
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade700,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
    );
  }
}
