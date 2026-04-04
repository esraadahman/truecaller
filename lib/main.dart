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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truecaller/core/di/di.dart';
import 'package:truecaller/core/overlay_helper/overlay_content.dart';
import 'package:truecaller/core/overlay_helper/permations_check.dart';
import 'package:truecaller/features/home_screen/logic/create_contact/cubit/create_contact_cubit.dart';
import 'package:truecaller/features/home_screen/logic/get_all_contacts/cubit/get_all_contacts_cubit.dart';
import 'package:truecaller/features/welcome/ui/screen/welcome.dart';
import 'package:permission_handler/permission_handler.dart';

/// Snapped once so the main isolate uses [TextScaler.linear] instead of
/// [SystemTextScaler], which calls JNI with a display configuration id.
/// That JNI path breaks when a second Flutter engine (overlay) is also running.
late final TextScaler mainAppTextScaler;

void main() async {
  print("🟢 [MAIN] main() started");
  WidgetsFlutterBinding.ensureInitialized();
  mainAppTextScaler = TextScaler.linear(
    WidgetsBinding.instance.platformDispatcher.textScaleFactor,
  );
  print("🟢 [MAIN] WidgetsFlutterBinding initialized");
  DartPluginRegistrant.ensureInitialized();
  print("🟢 [MAIN] DartPluginRegistrant initialized");

  await Permission.phone.request();
  // await forceCloseOverlay();
  // print("🟢 [MAIN] close all overlayes");
  await setupGetIt();
  print("🟢 [MAIN] GetIt setup done");
  await checkOverlayPermissionOnce();
  print("🟢 [MAIN] Overlay permission checked");
  if (await FlutterOverlayWindow.isActive()) {
    print("🟢 [MAIN] closing orphan overlay...");
    await FlutterOverlayWindow.closeOverlay();
  }
 // await PhoneStateService.init();
  print("🟢 [MAIN] PhoneStateService initialized");
  runApp(const MyApp());
  print("🟢 [MAIN] runApp called");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("🟢 [MyApp] build() called");
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<GetAllContactsCubit>()),
        BlocProvider(create: (context) => getIt<CreateContactCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          print("🟢 [MyApp] ScreenUtilInit builder() called");
          print(
            "🟢 [MyApp] ScreenUtil.screenWidth = //${ScreenUtil().screenWidth}",
          );
          print(
            "🟢 [MyApp] ScreenUtil.screenHeight = ${ScreenUtil().screenHeight}",
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(textScaler: mainAppTextScaler),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const Welcome(),
          );
        },
      ),
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
  DartPluginRegistrant.ensureInitialized();
  print("🔴 [OVERLAY] WidgetsFlutterBinding initialized in overlay isolate");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // Overlay windows often lack a valid configuration id for system font scaling.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: const TextScaler.linear(1)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const TrueCallerOverlay(),
    ),
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
