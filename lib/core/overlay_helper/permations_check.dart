import 'package:flutter_overlay_window/flutter_overlay_window.dart';

Future<void> checkOverlayPermissionOnce() async {
  bool isGranted = await FlutterOverlayWindow.isPermissionGranted();

  if (!isGranted) {
    // Only request if not already granted
    await FlutterOverlayWindow.requestPermission();
  }
}
