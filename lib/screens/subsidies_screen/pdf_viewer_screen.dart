import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';

class PDFViewerScreen extends StatefulWidget {
  final String? pdfUrl;
  final File? pdfFile;
  final String title;

  const PDFViewerScreen({
    Key? key,
    this.pdfUrl,
    this.pdfFile,
    required this.title,
  })  : assert(pdfUrl != null || pdfFile != null,
            'Either pdfUrl or pdfFile must be provided'),
        super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int? totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final t = translation(context);
    print(widget.pdfUrl);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isReady && totalPages != null)
              Text(
                '${t.page} ${currentPage + 1} ${t.ofTxt} $totalPages',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildPDFView(t),

          // Error message overlay
          if (errorMessage.isNotEmpty && !isReady)
            Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        t.errorLoadingPdf,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kCardTitleColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 12,
                          color: kCardDescColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPDFView(dynamic t) {
    final pdfWidget = PDF(
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      onError: (error) {
        setState(() {
          errorMessage = error.toString();
        });
        print('PDF Error: $error');
      },
      onPageError: (page, error) {
        setState(() {
          errorMessage = '$page: ${error.toString()}';
        });
        print('PDF Page Error: $page: ${error.toString()}');
      },
      onViewCreated: (PDFViewController pdfViewController) {
        // PDF view created
      },
      onLinkHandler: (String? uri) {
        print('Link clicked: $uri');
      },
      onPageChanged: (int? page, int? total) {
        setState(() {
          currentPage = page ?? 0;
          totalPages = total;
        });
      },
      onRender: (pages) {
        setState(() {
          isReady = true;
          totalPages = pages;
        });
      },
    );

    // Load from URL if provided
    if (widget.pdfUrl != null) {
      return pdfWidget.fromUrl(
        widget.pdfUrl!,
        placeholder: (progress) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: progress / 100,
                color: kPrimaryColor,
              ),
              SizedBox(height: 16),
              Text(
                '${t.loading} ${progress.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  color: kCardDescColor,
                ),
              ),
            ],
          ),
        ),
        errorWidget: (error) => _buildErrorWidget(t, error),
      );
    }

    // Load from file if provided
    if (widget.pdfFile != null) {
      return Stack(
        children: [
          pdfWidget.fromPath(widget.pdfFile!.path),
          if (!isReady && errorMessage.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    t.loading,
                    style: TextStyle(
                      fontSize: 14,
                      color: kCardDescColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return _buildErrorWidget(t, 'No PDF source provided');
  }

  Widget _buildErrorWidget(dynamic t, dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              t.errorLoadingPdf,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kCardTitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: kCardDescColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
