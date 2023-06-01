import 'package:flutter/material.dart';

class DeviceSize {
  static late double screenWidth;
  static late double screenHeight;
  static bool get isDesktopMode => screenWidth > 700;

  static void set(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    if (media == null) return;
    screenWidth = media.size.width;
    screenHeight = media.size.height;
  }
}

extension Numbers on num {
  double get widthPercent {
    return (this / 100) * DeviceSize.screenWidth;
  }

  double get heightPercent {
    return (this / 100) * DeviceSize.screenHeight;
  }
}
