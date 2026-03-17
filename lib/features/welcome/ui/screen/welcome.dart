import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:truecaller/core/routing/navigate.dart';
import 'package:truecaller/features/home_screen/ui/screen/home_screen.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.navigateTo(HomeScreen());
            },
            child: const Text("Next", style: TextStyle(fontSize: 20)),
          ),

          TextButton(
            onPressed: () async {
              final status = await FlutterOverlayWindow.isPermissionGranted();
              log("Is Permission Granted: $status");
            },
            child: const Text("Check Permission"),
          ),

          SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              if (await FlutterOverlayWindow.isActive()) return;
              await FlutterOverlayWindow.showOverlay(
                enableDrag: true,
                overlayTitle: "X-SLAYER",
                overlayContent: 'Overlay Enabled',
                flag: OverlayFlag.defaultFlag,
                visibility: NotificationVisibility.visibilityPublic,
                positionGravity: PositionGravity.auto,
                height: 700,
                width: 500,
                startPosition: const OverlayPosition(0, -259),
              );
            },
            child: const Text("Show Overlay"),
          ),
        ],
      ),
    );
  }
}
