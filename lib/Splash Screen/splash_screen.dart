// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lawyers_application/Admin%20Section/Admin%20Home%20Screen/admin_home_screen.dart';
import 'package:lawyers_application/Authentication/Screens/login_screen.dart';
import 'package:lawyers_application/Client%20Section/Client%20Home%20Screen/client_home_screen.dart';
import 'package:lawyers_application/Lawyer%20Section/Lawyer%20Home%20Screen/lawyer_home_screen.dart';
import 'package:lawyers_application/Splash%20Screen/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String? _userRole;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      checkIsLogin();
    });
  }

// this function is used to track that i user login before this attempted.
  Future<void> checkIsLogin() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      _isLogin = sharedPreferences.getBool('isLogin') ?? false;
    });

    if (_isLogin) {
      _userRole = await UserRole.getCurrentUserRole();
      if (_userRole != null) {
        _navigateToHomeScreen(_userRole!);
      }
    } else {
      _navigateToLoginScreen();
    }
  }

  void _navigateToHomeScreen(String role) {
    switch (role) {
      case 'Client':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ClientHomeScreen()),
        );
        break;
      case 'Lawyer':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LawyerHomeScreen()),
        );
        break;
      case 'Admin':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
        break;
      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const LoginScreen(),
        transitionsBuilder: (context, animation1, animation2, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation1,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/app_logo.png',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      // "Lawyer's App",
                      "Legal Ease",
                      style: GoogleFonts.aDLaMDisplay(
                        fontSize: 30,
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
