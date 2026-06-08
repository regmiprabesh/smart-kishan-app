import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';

void showErrorSnackbar(String message) =>
    _show(message, kErrorColor, Icons.error_outline);

void showSuccessSnackbar(String message) =>
    _show(message, kSuccessColor, Icons.check_circle_outline);

void _show(String message, Color color, IconData icon) {
  final ctx = Get.overlayContext;
  if (ctx == null) return;
  ScaffoldMessenger.of(ctx)
    ..hideCurrentSnackBar() // avoids stacked duplicates
    ..showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
}
