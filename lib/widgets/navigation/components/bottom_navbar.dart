// utils
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavbar extends StatefulWidget {
  final Function(int index) onPressed;
  final int currentIndex;

  const BottomNavbar({
    Key? key,
    required this.onPressed,
    required this.currentIndex,
  }) : super(key: key);

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(BottomNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentIndex) {
      setState(() {
        _currentIndex = widget.currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 60,
      margin: const EdgeInsets.only(left: 50, right: 50, bottom: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: GNav(
          rippleColor: Colors.grey[400]!,
          hoverColor: Colors.grey[400]!,
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.black, width: 1),
          tabBorder: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
          tabShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.25),
              blurRadius: 13,
            )
          ],
          curve: Curves.easeInToLinear,
          duration: const Duration(milliseconds: 419),
          gap: 8,
          color: Colors.grey,
          activeColor: Colors.black,
          iconSize: 24,
          tabBackgroundColor: Colors.grey.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(
            horizontal: 10.5,
            vertical: 5,
          ),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.download,
              text: "Downloads",
            ),
          ],
          onTabChange: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
              widget.onPressed(index);
            }
          },
          selectedIndex: _currentIndex,
        ),
      ),
    );
  }
}
