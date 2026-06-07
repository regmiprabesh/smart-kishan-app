import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';

class ProductSuccessScreen extends StatelessWidget {
  const ProductSuccessScreen({super.key, required this.isEdit});

  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("सफलता"),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                CircleAvatar(
                  backgroundColor: kPrimaryColor.withOpacity(0.2),
                  radius: 90,
                  child: Icon(
                    Icons.check,
                    color: kPrimaryColor,
                    size: 120,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  isEdit ? 'सफलतापूर्वक अपडेट गरियो' : 'सफलतापूर्वक थपियो',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  isEdit
                      ? 'तपाईंको उत्पादन बिक्रीको लागि सफलतापूर्वक अपडेट गरिएको छ। यो स्वीकृत भएपछि तपाईंलाई सूचित गरिनेछ।'
                      : 'तपाईंको उत्पादन बिक्रीको लागि सफलतापूर्वक थपिएको छ। यो स्वीकृत भएपछि तपाईंलाई सूचित गरिनेछ।',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('उत्पादनहरूमा फर्कनुहोस्'),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
