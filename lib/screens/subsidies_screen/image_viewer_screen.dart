import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';

class ImageViewerScreen extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String title;

  const ImageViewerScreen({
    Key? key,
    this.imageFile,
    this.imageUrl,
    required this.title,
  })  : assert(imageFile != null || imageUrl != null,
            'Either imageFile or imageUrl must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = translation(context);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: _buildImage(context, t),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, dynamic t) {
    // If imageFile is provided, use it
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(t, error);
        },
      );
    }

    // Otherwise use imageUrl
    return Image.network(
      imageUrl!,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: kPrimaryColor,
              ),
              SizedBox(height: 16),
              Text(
                t.loading ?? 'Loading image...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              if (loadingProgress.expectedTotalBytes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget(t, error);
      },
    );
  }

  Widget _buildErrorWidget(dynamic t, Object error) {
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
              t.errorLoadingImage ?? 'Error loading image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
