import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_kishan/constant.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:smart_kishan/size_config.dart';

class CameraPicker {
  static void cropImage(selectedImagepath, {required Function onPicked}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedImagepath,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath =
          '${dir.absolute.path}/${DateTime.now().microsecondsSinceEpoch}.jpeg';
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
          croppedFile.path, targetPath,
          quality: 25);
      onPicked(compressedFile!.path);
    } else {}
  }

  // Implementing the image picker
  static Future<void> imgFromCamera({required Function onPicked}) async {
    final XFile? pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedImage != null) {
      cropImage(pickedImage.path, onPicked: onPicked);
    }
  }

  // Implementing the image picker
  static Future<void> imgFromGallery({required Function onPicked}) async {
    final XFile? pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      cropImage(pickedImage.path, onPicked: onPicked);
    }
  }

  static showPicker(BuildContext context, {required Function onPicked}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              content: SafeArea(
                child: Container(
                  width: getProportionateScreenWidth(250),
                  color: kCanvasColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: SizeConfig.screenWidth,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Choose an action',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: getProportionateScreenWidth(16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Divider(
                        color: kPrimaryColor,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth,
                        height: getProportionateScreenHeight(10),
                      ),
                      Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                imgFromCamera(onPicked: onPicked);
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: getProportionateScreenWidth(80),
                                  height: getProportionateScreenWidth(80),
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(20)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.asset(
                                    'assets/images/camera_icon.png',
                                  )),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenWidth(5)),
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: getProportionateScreenWidth(20)),
                      Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                imgFromGallery(onPicked: onPicked);
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: getProportionateScreenWidth(80),
                                  height: getProportionateScreenWidth(80),
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(20)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.asset(
                                    'assets/images/gallery_icon.png',
                                  )),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenWidth(5)),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
