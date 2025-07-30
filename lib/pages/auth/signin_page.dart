import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  static const Color primaryColor = Color(0xFF6740BA);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie
                SizedBox(
                  height: 120,
                  child: Lottie.asset('assets/lottie/waving.json'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Login to your account',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _emailController,
                          hint: 'Email Address',
                          icon: Icons.email),
                      const SizedBox(height: 16),
                      CustomTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock,
                          isObscure: true),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _handleSignIn,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Sign In',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // Google login logic
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: Colors.grey.shade700),
                            backgroundColor: Colors.grey[850],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/google.png',
                                  height: 55),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // or navigate to SignUpPage
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      // Sign-in logic (to be added)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Success Placeholder')),
      );
    }
  }
}
