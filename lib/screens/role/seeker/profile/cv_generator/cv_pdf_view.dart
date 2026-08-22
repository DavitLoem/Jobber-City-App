import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows a generated CV PDF in-app — same `SfPdfViewer.network` pattern
/// already used for employers viewing a candidate's resume
/// (`candidate_detail/widgets/cv_viewer_view.dart`), just under the seeker's
/// own profile section instead. Pushed directly with `Get.to()` (no named
/// route needed — it's a leaf screen only reachable from CV Generator).
class CvPdfView extends StatelessWidget {
  final String pdfUrl;
  const CvPdfView({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'My CV',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.black87),
            tooltip: 'Open in browser / download',
            onPressed: () => launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          Get.snackbar(
            'Cannot Load CV',
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
