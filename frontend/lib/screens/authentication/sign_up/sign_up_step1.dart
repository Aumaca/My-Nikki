import 'package:my_nikki/screens/authentication/header.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/fields.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/validate.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';

class SignUpStep1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback googleSignUp;
  final VoidCallback onNext;
  final _formKey = GlobalKey<FormState>();
  final User? _user = null;

  SignUpStep1({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onNext,
    required this.googleSignUp,
  });

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
                    () => Navigator.pushNamed(context, '/login'),
                    AppColors.secondaryColor,
                    "or login"),
                const SizedBox(height: 32),
                SignInButton(
                  Buttons.google,
                  text: "Sign up with Google",
                  onPressed: () {
                    googleSignUp();
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
