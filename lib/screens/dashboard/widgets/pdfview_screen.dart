// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';
import 'package:cusit/extensions/aspect_ratio_extension.dart';
import 'package:cusit/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewScreen extends StatefulWidget {
  final File file;
  final int num;

  const PdfViewScreen({Key? key, required this.file, required this.num})
      : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  PDFViewController? controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.cusitclr,
        elevation: 0,
        foregroundColor: AppColors.blacklight,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            )),
        title: Image.asset(
          'assets/icons/Logowb.png',
           width: context.width * 0.3,
          height: context.height * 0.2,
        ),
        actions: pages >= 2
            ? [
                Center(child: Text(text,style: const TextStyle(color: AppColors.white),)),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 32,color: AppColors.white),
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    controller?.setPage(page);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 32,color: AppColors.white),
                  onPressed: () {
                    final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                    controller?.setPage(page);
                  },
                ),
              ]
            : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        fitPolicy: FitPolicy.WIDTH,
        enableSwipe: true,
        swipeHorizontal: true,

        // autoSpacing: false,
        // swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
      ),
    );
  }
}
