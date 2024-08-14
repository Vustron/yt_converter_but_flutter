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
