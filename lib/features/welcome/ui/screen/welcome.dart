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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.navigateTo(HomeScreen());
          },
          child: const Text("Next", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
