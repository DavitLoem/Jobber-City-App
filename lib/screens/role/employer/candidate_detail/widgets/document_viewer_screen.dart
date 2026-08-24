import 'package:flutter/material.dart';
import 'package:jobber_city/core/constants/app_colors.dart'; // តម្រូវតាមទីតាំងជាក់ស្តែងរបស់អ្នក
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String documentUrl;
  final String title;

  const DocumentViewerScreen({
    super.key,
    required this.documentUrl,
    this.title = "Document Viewer",
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // 🎯 ប្រើប្រាស់ Google Docs Viewer ដើម្បីបំប្លែង PDF/DOCX ឱ្យអាចមើលបានក្នុង WebView
    final formattedUrl = Uri.encodeComponent(widget.documentUrl);
    final googleDocsUrl =
        'https://docs.google.com/gview?embedded=true&url=$formattedUrl';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(googleDocsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
