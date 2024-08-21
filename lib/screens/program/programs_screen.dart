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
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.endsWith('.pdf')) {
              _handlePdfLink(request.url);
              return NavigationDecision.prevent;  // Prevent the WebView from loading the PDF link
            }
            return NavigationDecision.navigate;  // Allow the WebView to load the URL
          },
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (isLoading)
             Image.asset("assets/images/loading.gif"),
          ],
        ),
      ),
    );
  }
}
