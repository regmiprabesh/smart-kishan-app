import 'dart:math';

import 'package:flutter/material.dart';

final List<Color> randomColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
];

Color getRandomColor() {
  return randomColors[Random().nextInt(randomColors.length)];
}
