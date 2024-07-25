import 'package:http/http.dart';
import 'package:my_nikki/screens/authentication/sign_up/sign_up_step1.dart';
import 'package:my_nikki/screens/authentication/sign_up/sign_up_step2.dart';
import 'package:my_nikki/screens/widgets/snack_bar.dart';
import 'package:my_nikki/utils/requests.dart';
import 'package:my_nikki/utils/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/redirect.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class SignUp extends StatefulWidget {
  final UserCredential? userCredential;

  const SignUp({super.key, this.userCredential});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedCountry = "United States";
  UserCredential? userCredential;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  final Map<String, dynamic> _pageControllerData = {
    'duration': const Duration(milliseconds: 300),
    'curve': Curves.easeInOut,
  };

  void _nextPage() {
    _pageController.nextPage(
        duration: _pageControllerData['duration'],
        curve: _pageControllerData['curve']);
  }

  void _prevPage() {
    _pageController.nextPage(
        duration: _pageControllerData['duration'],
        curve: _pageControllerData['curve']);
  }

  void _handleGoogleSignUp() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleAuthProvider);
      setState(() {
        this.userCredential = userCredential;
        _emailController.text = userCredential.user!.email!;
        _passwordController.text = "*";
      });
      _nextPage();
    } catch (error) {
      Logger().e(error);
    }
  }

  void _registerGoogle() async {
    try {
      String? idToken = await userCredential!.user!.getIdToken();

      var data = {
        'idToken': idToken,
        'email': _emailController.text,
        'name': _nameController.text,
        'country': _selectedCountry,
      };

      Response response = await genericPost('/auth/google_register', data);

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        bool stored =
            await SecureStorage().writeToken(decodedResponse['token']);
        if (stored) {
          showSnackBar(context, "Sign up successful!", Colors.green);
          redirectTo(context, '/home');
        }
      } else {
        showSnackBar(context, "Error while signing up.", Colors.red);
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  void _register() async {
    try {
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'country': _selectedCountry,
      };
      Response response = await genericPost('/auth/register', data);

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        bool stored =
            await SecureStorage().writeToken(decodedResponse['token']);
        if (stored) {
          showSnackBar(context, "Sign up successful!", Colors.green);
          redirectTo(context, '/home');
        }
      } else {
        showSnackBar(context, "Error while signing up.",
            const Color.fromARGB(255, 0, 0, 0));
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> _executeRegister() async {
    if (userCredential != null) {
      _registerGoogle();
    } else {
      _register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SignUpStep1(
              emailController: _emailController,
              passwordController: _passwordController,
              googleSignUp: _handleGoogleSignUp,
              onNext: _nextPage),
          SignUpStep2(
            nameController: _nameController,
            selectedCountry: _selectedCountry,
            onChange: (newCountry) {
              setState(() {
                if (newCountry != null) {
                  _selectedCountry = newCountry;
                }
              });
            },
            onPrevious: _prevPage,
            onSubmit: _executeRegister,
          ),
        ],
      ),
    );
  }
}
