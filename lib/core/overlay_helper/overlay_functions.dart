import 'dart:developer';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

Future<void> forceCloseOverlay() async {
  int retryCount = 0;
  const maxRetries = 3;

  while (retryCount < maxRetries) {
    try {
      final isActive = await FlutterOverlayWindow.isActive();

      if (!isActive) {
        log('✅ Overlay already closed');
        return;
      }

      await FlutterOverlayWindow.closeOverlay();
      log('✅ Overlay closed successfully');

      // ✅ التأكد من الإغلاق
      await Future.delayed(const Duration(milliseconds: 300));
      final stillActive = await FlutterOverlayWindow.isActive();
      if (!stillActive) {
        return;
      }
    } catch (e) {
      retryCount++;
      log('❌ Failed to close overlay (attempt $retryCount/$maxRetries): $e');

      if (retryCount < maxRetries) {
        await Future.delayed(Duration(milliseconds: 500 * retryCount));
      }
    }
  }
}
