// ignore_for_file: use_build_context_synchronously

import 'package:cusit/screens/dashboard/widgets/pdfview_screen.dart';
import 'package:cusit/services/pdfservice.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProgramsFeeScreen extends StatefulWidget {
  static const String id = 'programs_screen';
  const ProgramsFeeScreen({super.key});

  @override
  State<ProgramsFeeScreen> createState() => _ProgramsFeeScreenState();
}

class _ProgramsFeeScreenState extends State<ProgramsFeeScreen> {
   late WebViewController _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });

            // Check for PDF links in the URL
            if (url.endsWith('.pdf')) {
              _handlePdfLink(url);
            }
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://cu.edu.pk/ProgramsOffered/'),
      );
  }

  void _handlePdfLink(String pdfUrl) async {
    try {
      final pdfFile = await PDFService.loadPDFFromNetwork(pdfUrl);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewScreen(file: pdfFile, num: 0),
        ),
      );
    } catch (e) {
      // Handle any errors (e.g., show an error message to the user)
      print("Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(
          controller: _webViewController,
        ),
      ),
    );
  }
}
