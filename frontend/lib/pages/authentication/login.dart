import 'package:my_nikki/pages/authentication/signUp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
      // Google sign up
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleAuthProvider);

      Map<String, dynamic> userData = {
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
        'isNewUser': userCredential.additionalUserInfo?.isNewUser,
        'photoURL': userCredential.user?.photoURL,
        'displayName': userCredential.user?.displayName,
      };

      print(userData);

      // Send data to register in backend db
      var url = Uri.parse("${dotenv.get('BACKEND_URL')}/auth/google_register");
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(userData));
    } catch (error) {
      print(error);
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
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width * 1.2,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.book,
                      size: 100,
                      color: AppColors.primaryColor,
                    ), // Replace this with your image later
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'LOGIN',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildLabel('Email'),
                    _buildTextField(_emailController),
                    const SizedBox(height: 16),
                    _buildLabel('Password'),
                    _buildTextField(_passwordController, isPassword: true),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (ModalRoute.of(context)?.settings.name !=
                            '/signup') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Center(
                        child: Text('or sign up',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            )),
                      ),
                    ),
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword && true,
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        fillColor: Color.fromRGBO(211, 211, 211, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontFamily: 'Poppins'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please, fill this field.';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sendDataToAPI();
    }
  }
}
