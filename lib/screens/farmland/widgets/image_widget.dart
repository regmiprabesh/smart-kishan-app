import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/screens/farmland/widgets/camera_picker.dart';
import 'package:smart_kishan/screens/farmland/widgets/elevated_button.dart';
import 'package:smart_kishan/size_config.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget(
      {super.key,
      required this.imageTitle,
      required this.onAdd,
      required this.placeHolderImage,
      required this.error,
      this.errorText,
      required this.networkImagePath});
  final String imageTitle;
  final Function onAdd;
  final String placeHolderImage;
  final bool error;
  final String? errorText;
  final String networkImagePath;
  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 7,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            side: widget.error &&
                    selectedImagePath == null &&
                    widget.networkImagePath.isEmpty
                ? const BorderSide(color: Colors.red)
                : const BorderSide(color: Colors.transparent)),
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15)),
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(widget.imageTitle),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      child: selectedImagePath != null
                          ? Image.file(
                              File(selectedImagePath!),
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            )
                          : widget.networkImagePath.isEmpty
                              ? Image.asset(
                                  widget.placeHolderImage,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.scaleDown,
                                )
                              : CachedNetworkImage(
                                  imageUrl: '$imgUrl${widget.networkImagePath}',
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                          baseColor: kBaseColor,
                                          highlightColor: kHightlightColor,
                                          child: Container(
                                            color: kPrimaryGrey,
                                          )),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: getProportionateScreenWidth(60),
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  widget.error &&
                          selectedImagePath == null &&
                          widget.networkImagePath.isEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.errorText != null ? widget.errorText! : '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.red),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedBtn(
                          title: 'Select',
                          onTap: () {
                            CameraPicker.showPicker(context,
                                onPicked: (String path) {
                              setState(() {
                                selectedImagePath = path;
                              });
                              widget.onAdd(path);
                            });
                          })),
                  const SizedBox(
                    height: 20,
                  )
                ]))));
  }
}
