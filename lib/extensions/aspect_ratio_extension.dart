import 'package:flutter/material.dart';

extension AspectRatioExtension on BuildContext {
  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }
}
