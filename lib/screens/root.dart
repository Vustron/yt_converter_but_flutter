// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yt_converter/utils/screen_list.dart';
import 'package:flutter/material.dart';

// screens
import 'package:yt_converter/screens/about.dart';

// widget
import 'package:yt_converter/widgets/navigation/components/bottom_navbar.dart';
import 'package:yt_converter/widgets/root/components/appbar.dart';

// root screen
class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  // set current screen index
  int currentIndex = 0;

  // init page controller
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomPadding > 0;

// TODO: naay bug sa overlay dra ang error,
//
// ══╡ EXCEPTION CAUGHT BY GESTURE LIBRARY ╞═══════════════════════════════════════════════════════════
// The following assertion was thrown while dispatching a pointer event:
// 'package:flutter/src/widgets/overlay.dart': Failed assertion: line 207 pos 12: '_overlay != null':
// is not true.

// When the exception was thrown, this was the stack:
// #2      OverlayEntry.remove (package:flutter/src/widgets/overlay.dart:207:12)
// #3      _SearchFieldState.removeOverlay (package:searchfield/src/searchfield.dart:419:24)
// #4      _SearchFieldState._suggestionsBuilder.<anonymous closure>.<anonymous closure>
// (package:searchfield/src/searchfield.dart:802:15)
// #5      RenderTapRegionSurface.handleEvent (package:flutter/src/widgets/tap_region.dart:279:28)
// #6      GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:475:22)
// #7      RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:425:11)
// #8      GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:420:7)
// #9      GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:383:5)
// #10     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:330:7)
// #11     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:299:9)
// #12     _invoke1 (dart:ui/hooks.dart:328:13)
// #13     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:442:7)
// #14     _dispatchPointerDataPacket (dart:ui/hooks.dart:262:31)
// (elided 2 frames from class _AssertionError)

// Event:
//   PointerDownEvent#35027(position: Offset(260.5, 714.0))
// Target:
//   RenderTapRegionSurface#78048
// ════════════════════════════════════════════════════════════════════════════════════════════════════

// Another exception was thrown: 'package:flutter/src/widgets/overlay.dart': Failed assertion: line 207 pos 12: '_overlay!= null': is not true.
//
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // screens
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: screens,
            ),

            // app bar
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: appbar(
                    currentIndex: currentIndex,
                    onAboutPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: const AboutScreen(),
                          ));
                    })),

            // bottom navbar
            if (!isKeyboardVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomNavbar(
                  onPressed: _onNavBarTapped,
                  currentIndex: currentIndex,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
