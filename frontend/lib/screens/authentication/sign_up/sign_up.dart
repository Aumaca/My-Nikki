import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_nikki/screens/authentication/sign_up/sign_up_step1.dart';
import 'package:my_nikki/screens/authentication/sign_up/sign_up_step2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedCountry = "United States";

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

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> sendDataToAPI() async {
    try {
      var url = Uri.parse("${dotenv.get('BACKEND_URL')}/auth/register");
      var data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'country': _selectedCountry,
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
          const SnackBar(content: Text('Sign up successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error while signing up.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request error: $e')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sendDataToAPI();
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
            onSubmit: _submitForm,
          ),
        ],
      ),
    );
  }
}
