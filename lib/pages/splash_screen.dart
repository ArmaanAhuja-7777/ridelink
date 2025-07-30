import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './auth/signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _textFadeController;
  late Animation<double> _circleAnimation;
  late Animation<double> _textFadeAnimation;

  static const Color primaryColor = Color(0xFF6740BA);

  @override
  void initState() {
    super.initState();

    // Circle expands slowly over 4 seconds
    _circleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _circleAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Curves.easeOutExpo,
      ),
    );

    // Text fades in halfway through
    _textFadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _textFadeAnimation = CurvedAnimation(
      parent: _textFadeController,
      curve: Curves.easeIn,
    );

    _circleController.forward();
    Future.delayed(const Duration(seconds: 1), () {
      _textFadeController.forward();
    });

    // Navigate after 4.5 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignUpPage()),
      );
    });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _circleAnimation,
        builder: (context, child) {
          return ClipPath(
            clipper: CircleClipper(_circleAnimation.value),
            child: Container(
              color: primaryColor,
              child: Center(
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    'Ridelink',
                    style: GoogleFonts.pacifico(
                      textStyle: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final double value;

  CircleClipper(this.value);

  @override
  Path getClip(Size size) {
    final radius = value * size.longestSide;
    final center = Offset(size.width / 2, size.height / 2);
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant CircleClipper oldClipper) {
    return oldClipper.value != value;
  }
}
