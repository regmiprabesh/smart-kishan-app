import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/cropInfo.dart';

class CropInfoScreen extends StatefulWidget {
  const CropInfoScreen({super.key, required this.cropInfo});
  final CropInfo cropInfo;
  @override
  State<CropInfoScreen> createState() => _CropInfoScreenState();
}

class _CropInfoScreenState extends State<CropInfoScreen> {
  late CropInfo cropInfo;

  @override
  void initState() {
    setState(() {
      cropInfo = widget.cropInfo;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(cropInfo.name!),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                cropInfo.image != null
                    ? CachedNetworkImage(
                        imageUrl: '$imgUrl${cropInfo.image!}',
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryGrey),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.contain),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryGrey),
                            image: const DecorationImage(
                                fit: BoxFit.contain,
                                image:
                                    AssetImage('assets/images/farmland.png'))),
                      ),
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: kPrimaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: [
                      Text(
                        cropInfo.name!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cropInfo.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cropInfo.activity!.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            initiallyExpanded:
                                index == 0 || index == 1 ? true : false,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: Text(
                              cropInfo.activity![index].title!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            expandedAlignment: Alignment.centerLeft,
                            children: <Widget>[
                              // Html(style: {
                              //   "p": Style(
                              //       fontSize: FontSize(13),
                              //       fontWeight: FontWeight.w500)
                              // }, data: cropInfo.activity![index].description!),
                              Text(cropInfo.activity![index].description!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  )),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ])),
        ));
  }
}
