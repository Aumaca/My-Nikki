import 'package:my_nikki/screens/authentication/header.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/fields.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_nikki/utils/api.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/validate.dart';
import 'package:my_nikki/utils/redirect.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void _handleGoogleLogin() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleAuthProvider);
      int statusCode = await handleGoogleAuth(userCredential);
      Logger().i("Status code: $statusCode");
    } catch (error) {
      Logger().e(error);
    }
  }

  Future<void> sendDataToAPI() async {
    try {
      var url = Uri.parse("${dotenv.get('BACKEND_URL')}/auth/login");
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error logging in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context, "LOGIN"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildLabel('Email'),
                    buildTextField(_emailController),
                    const SizedBox(height: 16),
                    buildLabel('Password'),
                    buildTextField(_passwordController, isPassword: true),
                    const SizedBox(height: 32),
                    buildElevatedButton(
                        context,
                        () => validateAndPass(_formKey, _submitForm),
                        AppColors.primaryColor,
                        "Login"),
                    buildElevatedButton(
                        context,
                        () => redirectTo(context, '/sign_up'),
                        AppColors.secondaryColor,
                        "or sign up"),
                    const SizedBox(height: 32),
                    SignInButton(
                      Buttons.google,
                      text: "Login with Google",
                      onPressed: () {
                        _handleGoogleLogin();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sendDataToAPI();
    }
  }
}
