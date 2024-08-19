
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProgramsFeeScreen extends StatefulWidget {
  static const String id = 'programs_screen';
  const ProgramsFeeScreen({super.key});

  @override
  State<ProgramsFeeScreen> createState() => _ProgramsFeeScreenState();
}

class _ProgramsFeeScreenState extends State<ProgramsFeeScreen> {
  late WebViewController controller;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
     ..setJavaScriptMode(JavaScriptMode.unrestricted) // Ensure JavaScript is enabled
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: AppColors.cusitclr,
        //   elevation: 0,
        //   foregroundColor: AppColors.white,
        //   title: Image.asset(
        //     'assets/icons/Logowb.png',
        //     width: context.width * 0.3,
        //     height: context.height * 0.2,
        //   ),
        //   centerTitle: true,
        // ),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
