import "package:my_nikki/utils/secure_storage.dart";
import "package:my_nikki/utils/requests.dart";
import "package:my_nikki/utils/colors.dart";
import "package:flutter/material.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    String? token = await SecureStorage().readToken();

    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    bool isAuthenticated = await isTokenValid();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
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
