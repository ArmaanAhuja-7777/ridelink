import 'package:flutter/material.dart';
import 'package:ridelink/pages/home_page.dart';
import 'package:ridelink/pages/profile_page.dart';
import 'package:ridelink/pages/rides_page.dart';
import 'package:ridelink/widgets/animated_bottom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const RidesPage(),
    const ProfilePage(),
  ];

  final List<String> _titles = [
    'Home',
    'Rides',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: const Color(0xFF6740BA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
