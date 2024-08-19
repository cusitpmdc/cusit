// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:developer';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/screens/dashboard/widgets/pdfview_screen.dart';
import 'package:cusit/services/pdfservice.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProspectusScreen extends StatefulWidget {
  static const String id = 'prospectus_screen';
  const ProspectusScreen({super.key});

  @override
  State<ProspectusScreen> createState() => _ProspectusScreenState();
}

class _ProspectusScreenState extends State<ProspectusScreen> {
  bool isPdfLoading = false;
  late String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewAttachment();
  }

  Future<void> viewAttachment() async {
    setState(() {
      isPdfLoading = true;
      errorMessage = null;
    });

    try {
      String url = 'https://cityuniversity.edu.pk/wp-content/uploads/2024/07/Prospectus-2024-Full-File.pdf';
      log(url);
      final file = await PDFService.loadPDFFromNetwork(url);

      if (file != null) {
        openPDF(context, file);
      } else {
        setState(() {
          errorMessage = 'Failed to load the PDF file.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while loading the PDF: $e';
      });
    } finally {
      setState(() {
        isPdfLoading = false;
      });
    }
  }

  void openPDF(BuildContext context, file) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PdfViewScreen(
          file: file,
          num: 0,
        ),
      ),
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
      body: Center(
        child: isPdfLoading
            ?  Image.asset("assets/images/loading.gif")
            : errorMessage != null
                ? Text(errorMessage!)
                : const Text('PDF loaded successfully!'),
      ),
    );
  }
}
