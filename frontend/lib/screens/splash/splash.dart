import "package:flutter/material.dart";
import "package:my_nikki/utils/colors.dart";
import "package:my_nikki/utils/requests.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    bool isAuthenticated = await isTokenValid();
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
          child: CircularProgressIndicator(
        color: AppColors.secondaryColor,
      )),
    );
  }
}
