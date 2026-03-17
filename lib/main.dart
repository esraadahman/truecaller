// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:truecaller/core/database/database_helper.dart';
// import 'package:truecaller/core/di/di.dart';
// import 'package:truecaller/core/overlay_helper/overlay_content.dart';
// import 'package:truecaller/core/overlay_helper/permations_check.dart';
// import 'package:truecaller/core/services/phone_state_service.dart';
// import 'package:truecaller/core/theme/theme.dart';
// import 'package:truecaller/features/home_screen/logic/create_contact/cubit/create_contact_cubit.dart';
// import 'package:truecaller/features/home_screen/logic/get_all_contacts/cubit/get_all_contacts_cubit.dart';
// import 'package:truecaller/features/welcome/ui/screen/welcome.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   await setupGetIt();
//   await checkOverlayPermissionOnce();
//   await PhoneStateService.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: const Welcome(), // ✅ builds AFTER ScreenUtil is ready
//         );
//       },
//       // no child: needed
//     );
//   }
// }

// // overlay entry point
// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const OverlayApp());
// }

// class OverlayApp extends StatelessWidget {
//   const OverlayApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: TrueCallerOverlay(),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truecaller/core/di/di.dart';
import 'package:truecaller/core/overlay_helper/overlay_content.dart';
import 'package:truecaller/core/overlay_helper/overlay_functions.dart';
import 'package:truecaller/core/overlay_helper/permations_check.dart';
import 'package:truecaller/core/services/phone_state_service.dart';
import 'package:truecaller/features/welcome/ui/screen/welcome.dart';

void main() async {
  print("🟢 [MAIN] main() started");
  WidgetsFlutterBinding.ensureInitialized();
  print("🟢 [MAIN] WidgetsFlutterBinding initialized");
  DartPluginRegistrant.ensureInitialized();
  print("🟢 [MAIN] DartPluginRegistrant initialized");
  await forceCloseOverlay();
  print("🟢 [MAIN] close all overlayes");
  await setupGetIt();
  print("🟢 [MAIN] GetIt setup done");
  await checkOverlayPermissionOnce();
  print("🟢 [MAIN] Overlay permission checked");
  await PhoneStateService.init();
  print("🟢 [MAIN] PhoneStateService initialized");
  runApp(const MyApp());
  print("🟢 [MAIN] runApp called");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("🟢 [MyApp] build() called");
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        print("🟢 [MyApp] ScreenUtilInit builder() called");
        print(
          "🟢 [MyApp] ScreenUtil.screenWidth = ${ScreenUtil().screenWidth}",
        );
        print(
          "🟢 [MyApp] ScreenUtil.screenHeight = ${ScreenUtil().screenHeight}",
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Welcome(),
        );
      },
    );
  }
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  // forceCloseOverlay();
  print(
    "🔴 [OVERLAY] overlayMain() started ← if you see this during app use, this is the conflict",
  );
  WidgetsFlutterBinding.ensureInitialized();
  print("🔴 [OVERLAY] WidgetsFlutterBinding initialized in overlay isolate");
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: TrueCallerOverlay()),
  );
  print("🔴 [OVERLAY] runApp(OverlayApp) called");
}

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("🔴 [OverlayApp] build() called");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrueCallerOverlay(),
    );
  }
}

