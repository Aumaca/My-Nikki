import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedCountry = "United States";
  String _userCoordinates = "";

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
      var url = Uri.parse(""); // Replace with your actual API URL
      var data = {
        'name': _nameController.text,
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
            onNext: _nextPage,
          ),
          SignUpStep2(
            nameController: _nameController,
            onPrevious: _prevPage,
            onNext: _nextPage,
          ),
          SignUpStep3(
            selectedCountry: _selectedCountry,
            userCoordinates: _userCoordinates,
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

class SignUpStep1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onNext;

  const SignUpStep1({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
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
              'SIGN UP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            _buildLabel('Email'),
            _buildTextField(emailController),
            const SizedBox(height: 16),
            _buildLabel('Password'),
            _buildTextField(passwordController, isPassword: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpStep2 extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const SignUpStep2({
    super.key,
    required this.nameController,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
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
              'SIGN UP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            _buildLabel('Name'),
            _buildTextField(nameController),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onPrevious,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Previous',
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
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpStep3 extends StatelessWidget {
  final String selectedCountry;
  final String userCoordinates;
  final ValueChanged<String?> onChange;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const SignUpStep3({
    super.key,
    required this.selectedCountry,
    required this.userCoordinates,
    required this.onChange,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
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
              'SIGN UP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            _buildLabel('Your country'),
            _buildCountryDropdown(selectedCountry, onChange),
            const SizedBox(height: 32),
            _buildLabel('Your address'),
            // FlutterMap(mapController: MapController(get),)
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onPrevious,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Previous',
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
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(
      String selectedCountry, ValueChanged<String?> onChange) {
    List<String> countries = [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'Germany',
      'France',
      'Italy',
      'Spain',
      'Brazil',
      'Mexico',
      'Japan',
      'China',
      'India',
      'Russia',
      'South Korea',
      'South Africa',
      'Argentina',
      'Chile',
      'Colombia',
      'Netherlands',
      'Sweden',
      'Norway',
      'Denmark',
      'Finland',
      'Belgium',
      'Switzerland',
      'Austria',
      'New Zealand',
      'Ireland',
      'Portugal',
      'Greece',
      'Turkey',
      'Poland',
      'Czech Republic',
      'Hungary',
      'Israel',
      'Saudi Arabia',
      'United Arab Emirates',
      'Singapore',
      'Malaysia',
      'Indonesia',
      'Thailand',
      'Vietnam',
      'Philippines',
      'Egypt',
      'Nigeria',
      'Kenya',
      'Morocco',
      'Peru',
      'Venezuela'
    ];

    return DropdownButtonFormField<String>(
      value: selectedCountry,
      onChanged: onChange,
      items: countries.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromRGBO(105, 37, 190, 1),
            ),
          ),
        );
      }).toList(),
      decoration: const InputDecoration(
        fillColor: Color.fromRGBO(211, 211, 211, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
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
        fontWeight: FontWeight.bold,
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
