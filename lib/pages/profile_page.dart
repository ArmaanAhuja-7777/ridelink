import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/coming_soon.json',
          height: 200,
          repeat: true,
        ),
        const Text(
          "Profile Page coming soon...",
          style: TextStyle(
            fontSize: 22, // make it a bit large
            fontWeight: FontWeight.w500,
            color: Colors.grey, // soft gray
          ),
        ),
      ],
    ));
  }
}
