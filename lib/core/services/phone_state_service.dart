// import 'package:flutter/material.dart';
// import 'package:phone_state/phone_state.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:truecaller/core/database/database_helper.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:truecaller/core/overlay_helper/overlay_content.dart';

// class PhoneStateService {
//   static bool _listening = false;

//   /// Call this once in main() to start listening anywhere in the app
//   static Future<void> init() async {
//     if (_listening) return;

//     // Request permission (Android only)
//     var status = await Permission.phone.request();
//     if (!status.isGranted) return;

//     // Listen to phone state
//     PhoneState.stream.listen((PhoneState? event) async {
//       if (event == null || event.number == null) return;

//       final number = event.number;
//       final status = event.status;
//       if (status == PhoneStateStatus.CALL_INCOMING && number != null) {
//         final contact = await DatabaseHelper.instance.getContactByNumber(
//           number,
//         );
//         String contentText = contact != null
//             ? "found|${contact.id}|${contact.name}|${contact.phone}|${contact.lastFollowUpNotes}|${contact.priority}|${contact.stage}"
//             : "not_found||Unknown Caller|$number|No follow up yet|No priority|New";

//         if (!(await FlutterOverlayWindow.isPermissionGranted())) return;

//         // ✅ مهم جدًا: متفتحش overlay لو شغال
//         if (await FlutterOverlayWindow.isActive()) {
//           await FlutterOverlayWindow.closeOverlay();
//           await Future.delayed(const Duration(milliseconds: 300));
//         }

//         // String contentText;

//         // if (contact != null) {
//         //   contentText =
//         //       "found|${contact.id}|${contact.name}|${contact.phone}|${contact.lastFollowUpNotes}|${contact.priority}|${contact.stage}";
//         // } else {
//         //   contentText =
//         //       "not_found||Unknown Caller|$number|No follow up yet|No priority|New";
//         // }

//         await FlutterOverlayWindow.showOverlay(
//           height: WindowSize.matchParent, // ✅ مهم
//           width: WindowSize.matchParent, // ✅ مهم
//           enableDrag: true,
//           overlayTitle: "X-SLAYER",
//           flag: OverlayFlag.defaultFlag,
//           visibility: NotificationVisibility.visibilityPublic,
//           positionGravity: PositionGravity.none,
//           alignment: OverlayAlignment.center,
//           overlayContent: contentText,
//         );

//         await FlutterOverlayWindow.shareData(contentText);
//       } else if (status == PhoneStateStatus.CALL_ENDED) {
//         await Future.delayed(const Duration(milliseconds: 100));
//         await FlutterOverlayWindow.closeOverlay();
//         // if (await FlutterOverlayWindow.isActive()) {
//         //  await FlutterOverlayWindow.closeOverlay();
//         // }
//       }
//     });
//     _listening = true;
//   }
// }

import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truecaller/core/database/database_helper.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:truecaller/core/overlay_helper/overlay_functions.dart';

class PhoneStateService {
  static bool _listening = false;

  static Future<void> init() async {
    print("📞 [PhoneStateService] init() called, _listening=$_listening");
    if (_listening) {
      print("📞 [PhoneStateService] already listening, skipping");
      return;
    }

    var status = await Permission.phone.request();
    print("📞 [PhoneStateService] phone permission status=$status");
    if (!status.isGranted) {
      print("📞 [PhoneStateService] ❌ permission not granted, aborting");
      return;
    }

    PhoneState.stream.listen((PhoneState? event) async {
      if (event == null || event.number == null) {
        print("📞 [PhoneStateService] received null event, skipping");
        return;
      }

      final number = event.number;
      final callStatus = event.status;
      print(
        "📞 [PhoneStateService] event received → number=$number, status=$callStatus",
      );

      if (callStatus == PhoneStateStatus.CALL_INCOMING && number != null) {
        print("📞 [PhoneStateService] incoming call from $number");

        final contact = await DatabaseHelper.instance.getContactByNumber(
          number,
        );
        print(
          "📞 [PhoneStateService] contact lookup result: ${contact != null ? 'FOUND → ${contact.name}' : 'NOT FOUND'}",
        );

        String contentText = contact != null
            ? "found|${contact.id}|${contact.name}|${contact.phone}|${contact.lastFollowUpNotes}|${contact.priority}|${contact.stage}"
            : "not_found||Unknown Caller|$number|No follow up yet|No priority|New";
        print("📞 [PhoneStateService] contentText=$contentText");

        final hasPermission = await FlutterOverlayWindow.isPermissionGranted();
        print(
          "📞 [PhoneStateService] overlay permission granted=$hasPermission",
        );
        if (!hasPermission) return;

        final isActive = await FlutterOverlayWindow.isActive();
        print("📞 [PhoneStateService] overlay isActive=$isActive");
        if (isActive) {
          print("📞 [PhoneStateService] closing existing overlay...");
          //    await FlutterOverlayWindow.closeOverlay();
          //   await Future.delayed(const Duration(milliseconds: 300));
          forceCloseOverlay();
          print("📞 [PhoneStateService] overlay closed");
        }

        print("📞 [PhoneStateService] showing overlay...");
        await FlutterOverlayWindow.showOverlay(
          height: WindowSize.matchParent,
          width: WindowSize.matchParent,
          enableDrag: true,
          overlayTitle: "X-SLAYER",
          flag: OverlayFlag.defaultFlag,
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.none,
          alignment: OverlayAlignment.center,
          overlayContent: contentText,
        );
        print("📞 [PhoneStateService] overlay shown");

        await FlutterOverlayWindow.shareData(contentText);
        print("📞 [PhoneStateService] data shared to overlay");
      } else if (callStatus == PhoneStateStatus.CALL_ENDED) {
        print("📞 [PhoneStateService] call ended");
        final isActive = await FlutterOverlayWindow.isActive();
        print("📞 [PhoneStateService] overlay isActive=$isActive on call end");
        if (isActive) {
          forceCloseOverlay();
          print("📞 [PhoneStateService] overlay closed on call end");
        }
      }
    });

    _listening = true;
    print("📞 [PhoneStateService] ✅ now listening to phone state");
  }
}
