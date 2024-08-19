
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AdmissionScreen extends StatefulWidget {
  static const String id = 'admission_screen';
  const AdmissionScreen({super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
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
        Uri.parse('https://cup.edu.pk/registration.php'),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: AppColors.cusitclr,
        elevation: 0,
        foregroundColor: AppColors.white,
        title: Image.asset(
          'assets/icons/Logowb.png',
          width: context.width * 0.3,
          height: context.height * 0.2,
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
      
    );
  }
}
