import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AnimatedBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AnimatedBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3C3B40),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color(0xFF6740BA),
              color: Colors.grey,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.directions_car,
                  text: 'Rides',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
