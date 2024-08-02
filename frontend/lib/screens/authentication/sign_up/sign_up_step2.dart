import 'package:my_nikki/screens/authentication/header.dart';
import 'package:my_nikki/screens/widgets/dropdown.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/fields.dart';
import 'package:my_nikki/utils/validate.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';

class SignUpStep2 extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedCountry;
  final void Function(String?) onChange;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final _formKey = GlobalKey<FormState>();

  SignUpStep2({
    super.key,
    required this.nameController,
    required this.selectedCountry,
    required this.onChange,
    required this.onPrevious,
    required this.onSubmit,
  });

  static List<String> countries = [
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        buildHeader(context, "Sign up"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildLabel('Name'),
                buildTextField(nameController),
                const SizedBox(height: 32),
                buildLabel('Your country'),
                buildDropdown(selectedCountry, onChange, countries),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildElevatedButton(context, onPrevious,
                        AppColors.primaryColor, "Previous"),
                    buildElevatedButton(
                        context,
                        () => validateAndPass(_formKey, onSubmit),
                        AppColors.primaryColor,
                        "Next"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
