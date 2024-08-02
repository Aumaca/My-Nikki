import 'package:my_nikki/screens/authentication/header.dart';
import 'package:my_nikki/screens/widgets/snack_bar.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/fields.dart';
import 'package:my_nikki/utils/secure_storage.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/requests.dart';
import 'package:my_nikki/utils/validate.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

  String? emailErrorMessage;
  String? passwordErrorMessage;

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

      Map<String, dynamic> data = {
        "idToken": await userCredential.user!.getIdToken(),
      };

      Response response = await genericPost("/auth/google_login", data);

      var decodedResponse = jsonDecode(response.body);
      String token = decodedResponse['token'];
      if (response.statusCode == 200) {
        await SecureStorage().writeToken(token);
        Navigator.pushNamed(context, '/home');
        return;
      } else if (response.statusCode == 400) {
        showSnackBar(context, "Google account not signed up.", Colors.red);
        Navigator.pushNamed(context, '/sign_up');
        return;
      }
    } catch (error) {
      showSnackBar(context, "Error while logging.", Colors.red);
    }
  }

  Future<void> executeLogin() async {
    try {
      Map<String, dynamic> data = {
        'email': _emailController.text,
        'password': _passwordController.text
      };

      Response response = await genericPost("/auth/login", data);
      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await SecureStorage().writeToken(decodedResponse['token']);

        showSnackBar(context, "Login successful!", Colors.green);
        Navigator.pushNamed(context, '/home');
        return;
      } else if (response.statusCode == 400) {
        if (decodedResponse["field"] == "email") {
          showSnackBar(context, "Could not find your account.", Colors.red);
        } else if (decodedResponse["field"] == "password") {
          showSnackBar(context, "Incorrect password.", Colors.red);
        }
      } else {
        showSnackBar(context, "Failed to login.", Colors.red);
      }
    } catch (e) {
      showSnackBar(context, "Error while logging.", Colors.red);
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
                    buildTextField(
                      _emailController,
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Password'),
                    buildTextField(_passwordController, isPassword: true),
                    const SizedBox(height: 32),
                    buildElevatedButton(
                        context,
                        () => validateAndPass(_formKey, _submitForm),
                        AppColors.primaryColor,
                        text: "Login"),
                    buildElevatedButton(
                        context,
                        () => Navigator.pushNamed(context, '/sign_up'),
                        AppColors.secondaryColor,
                        text: "or sign up"),
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
      executeLogin();
    }
  }
}
