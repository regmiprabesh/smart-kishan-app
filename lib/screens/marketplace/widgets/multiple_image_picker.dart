import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_kishan/constant.dart';

class MultipleImagePicker extends StatefulWidget {
  final Function(List<String>)
      onImageSelected; // Callback to send selected images
  final List<String> selectedImages;
  final List<String>? networkImages; // List of network image URLs

  MultipleImagePicker({
    required this.onImageSelected,
    required this.selectedImages,
    this.networkImages,
  });

  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    // Prevent picking more than the allowed total of 5 images
    if ((widget.selectedImages.length + (widget.networkImages?.length ?? 0)) >=
        5) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        widget.selectedImages.add(pickedFile.path);
      });
      widget.onImageSelected(
          widget.selectedImages); // Notify parent widget of updated images
    }
  }

  void _removeImage(int index, {bool isNetwork = false}) {
    setState(() {
      if (isNetwork) {
        widget.networkImages?.removeAt(index); // Remove network image
      } else {
        widget.selectedImages.removeAt(index); // Remove local image
      }
      widget.onImageSelected(
          widget.selectedImages); // Notify parent widget of updated images
    });
  }

  @override
  Widget build(BuildContext context) {
    // Total images (local + network)
    final totalImages =
        widget.selectedImages.length + (widget.networkImages?.length ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: totalImages < 5
              ? totalImages + 1
              : 5, // Add "Add Image" button if total < 5
          itemBuilder: (context, index) {
            // Show network images first
            if (widget.networkImages != null &&
                index < widget.networkImages!.length) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$imgUrl${widget.networkImages![index]}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _removeImage(index, isNetwork: true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Show locally selected images after network images
            final localIndex = index - (widget.networkImages?.length ?? 0);
            if (localIndex < widget.selectedImages.length) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.selectedImages[localIndex]),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _removeImage(localIndex),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Add "Add Image" button if the total images are less than 5
            return GestureDetector(
              onTap: totalImages < 5 ? _pickImage : null,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: totalImages < 5 ? Colors.green : Colors.grey,
                  size: 35,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
