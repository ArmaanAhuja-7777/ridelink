import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../pages/home_page.dart';
import '../pages/rides_page.dart';
import '../pages/profile_page.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  List<Widget> _buildScreens() {
    return const [
      HomePage(),
      RidesPage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorSecondary: Colors.white,
        activeColorPrimary: const Color(0xFF6740BA),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.directions_car),
        title: "Rides",
        activeColorSecondary: Colors.white,
        activeColorPrimary: const Color(0xFF6740BA),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorSecondary: Colors.white,
        activeColorPrimary: const Color(0xFF6740BA),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: const Color(0xFF3C3B40), // slight transparent
      navBarHeight: 65,
      navBarStyle: NavBarStyle.style7, // Stylish curved icon + label
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(50),
        colorBehindNavBar: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      resizeToAvoidBottomInset: true,
      stateManagement: true,
    );
  }
}
