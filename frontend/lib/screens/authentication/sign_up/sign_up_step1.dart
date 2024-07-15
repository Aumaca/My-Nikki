import 'package:my_nikki/screens/authentication/header.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/fields.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/redirect.dart';
import 'package:my_nikki/utils/validate.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:my_nikki/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SignUpStep1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onNext;
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? _user = null;

  SignUpStep1({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onNext,
  });

  void _handleGoogleSignUp(BuildContext context) async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleAuthProvider);
      int statusCode = await handleGoogleAuth(userCredential);
      Logger().i("Status code: $statusCode");

      // Logged in
      if (statusCode == 200) {
        redirectTo(context, "home");
      } else if (statusCode == 201) {
        emailController.text = userCredential.user!.email!;
        passwordController.text = ".";
        onNext();
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        buildHeader(context, "SIGN UP"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildLabel('Email'),
                buildTextField(emailController),
                const SizedBox(height: 16),
                buildLabel('Password'),
                buildTextField(passwordController, isPassword: true),
                const SizedBox(height: 32),
                buildElevatedButton(
                    context,
                    () => validateAndPass(_formKey, onNext),
                    AppColors.primaryColor,
                    "Next"),
                buildElevatedButton(
                    context,
                    () => redirectTo(context, '/login'),
                    AppColors.secondaryColor,
                    "or login"),
                const SizedBox(height: 32),
                SignInButton(
                  Buttons.google,
                  text: "Login with Google",
                  onPressed: () {
                    _handleGoogleSignUp(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
