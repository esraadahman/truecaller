// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// class TrueCallerOverlay extends StatefulWidget {
//   const TrueCallerOverlay({super.key});

//   @override
//   State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
// }

// class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
//   StreamSubscription? _overlaySub;

//   bool isFound = true;

//   String name = '';
//   String phone = '';
//   String lastFollowUpNotes = '';
//   String priority = '';
//   String stage = '';

//   final List<Color> foundColors = const [
//     Color(0xFFa2790d),
//     Color(0xFFebd197),
//     Color(0xFFa2790d),
//   ];

//   final List<Color> notFoundColors = const [
//     Color(0xFF8B0000),
//     Color(0xFFD32F2F),
//     Color(0xFFFF8A80),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initOverlay();
//   }

//   Future<void> _initOverlay() async {
//     await FlutterOverlayWindow.closeOverlay();

//     _overlaySub?.cancel();
//     _overlaySub = FlutterOverlayWindow.overlayListener.listen((event) {
//       if (event == null || !mounted) return;

//       final parts = event.toString().split('|');

//       setState(() {
//         isFound = parts.isNotEmpty && parts[0] == 'found';
//         name = parts.length > 2 ? parts[2] : '';
//         phone = parts.length > 3 ? parts[3] : '';
//         lastFollowUpNotes = parts.length > 4 ? parts[4] : '';
//         priority = parts.length > 5 ? parts[5] : '';
//         stage = parts.length > 6 ? parts[6] : '';
//       });
//     });

//     if (mounted) setState(() {});
//   }

//   @override
//   void dispose() {
//     _overlaySub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = isFound ? foundColors : notFoundColors;

//     return Material(
//       color: Colors.transparent,
//       child: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
//           padding: const EdgeInsets.all(16),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: colors,
//             ),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: const [
//               BoxShadow(
//                 blurRadius: 10,
//                 color: Colors.black26,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         isFound ? Icons.person : Icons.person_off,
//                         size: 32,
//                         color: isFound ? Colors.amber[800] : Colors.red[800],
//                       ),
//                     ),
//                     title: Text(
//                       name.isNotEmpty ? name : "Unknown Caller",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     subtitle: Text(
//                       phone.isNotEmpty ? phone : "No number",
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildRow("Last follow up", lastFollowUpNotes),
//                         const SizedBox(height: 8),
//                         _buildRow("Priority", priority),
//                         const SizedBox(height: 8),
//                         _buildRow("Stage", stage),
//                         if (!isFound) ...[
//                           const SizedBox(height: 12),
//                           const Row(
//                             children: [
//                               Icon(
//                                 Icons.warning_amber_rounded,
//                                 color: Colors.white,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "This number does not exist in your system.",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 top: -8,
//                 right: -8,
//                 child: IconButton(
//                   onPressed: () async {
//                     await FlutterOverlayWindow.closeOverlay();
//                   },
//                   icon: const Icon(Icons.close, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(String title, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 110,
//           child: Text(
//             "$title:",
//             style: const TextStyle(
//               color: Colors.white70,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         Text(
//           value.isNotEmpty ? value : "-",
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({super.key});

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  StreamSubscription? _overlaySub;

  bool isFound = true;
  String name = '';
  String phone = '';
  String lastFollowUpNotes = '';
  String priority = '';
  String stage = '';

  final List<Color> foundColors = const [
    Color(0xFFa2790d),
    Color(0xFFebd197),
    Color(0xFFa2790d),
  ];

  final List<Color> notFoundColors = const [
    Color(0xFF8B0000),
    Color(0xFFD32F2F),
    Color(0xFFFF8A80),
  ];

  @override
  void initState() {
    super.initState();
    print("🔴 [TrueCallerOverlay] initState() called");
    _initOverlay();
  }

  Future<void> _initOverlay() async {
    print("🔴 [TrueCallerOverlay] _initOverlay() started");

    final isActive = await FlutterOverlayWindow.isActive();
    print("🔴 [TrueCallerOverlay] isActive before close=$isActive");

    _overlaySub?.cancel();
    print("🔴 [TrueCallerOverlay] previous subscription cancelled");

    _overlaySub = FlutterOverlayWindow.overlayListener.listen(
      (event) {
        print("🔴 [TrueCallerOverlay] overlayListener event received: $event");
        if (event == null || !mounted) {
          print("🔴 [TrueCallerOverlay] event is null or widget not mounted, skipping");
          return;
        }

        final parts = event.toString().split('|');
        print("🔴 [TrueCallerOverlay] parsed parts: $parts");

        setState(() {
          isFound = parts.isNotEmpty && parts[0] == 'found';
          name = parts.length > 2 ? parts[2] : '';
          phone = parts.length > 3 ? parts[3] : '';
          lastFollowUpNotes = parts.length > 4 ? parts[4] : '';
          priority = parts.length > 5 ? parts[5] : '';
          stage = parts.length > 6 ? parts[6] : '';
        });

        print("🔴 [TrueCallerOverlay] state updated → isFound=$isFound, name=$name, phone=$phone");
      },
      onError: (error) {
        print("🔴 [TrueCallerOverlay] ❌ overlayListener error: $error");
      },
      onDone: () {
        print("🔴 [TrueCallerOverlay] overlayListener stream closed");
      },
    );

    print("🔴 [TrueCallerOverlay] overlayListener subscription started");

    if (mounted) {
      setState(() {});
      print("🔴 [TrueCallerOverlay] initial setState called");
    }
  }

  @override
  void dispose() {
    print("🔴 [TrueCallerOverlay] dispose() called");
    _overlaySub?.cancel();
    _overlaySub = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🔴 [TrueCallerOverlay] build() called → isFound=$isFound, name=$name");
    final colors = isFound ? foundColors : notFoundColors;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black26,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        isFound ? Icons.person : Icons.person_off,
                        size: 32,
                        color: isFound ? Colors.amber[800] : Colors.red[800],
                      ),
                    ),
                    title: Text(
                      name.isNotEmpty ? name : "Unknown Caller",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      phone.isNotEmpty ? phone : "No number",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildRow("Last follow up", lastFollowUpNotes),
                        const SizedBox(height: 8),
                        _buildRow("Priority", priority),
                        const SizedBox(height: 8),
                        _buildRow("Stage", stage),
                        if (!isFound) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "This number does not exist in your system.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  onPressed: () async {
                    print("🔴 [TrueCallerOverlay] close button pressed");
                    await FlutterOverlayWindow.closeOverlay();
                    print("🔴 [TrueCallerOverlay] overlay closed by user");
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            "$title:",
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : "-",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}