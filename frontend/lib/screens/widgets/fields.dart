import "package:flutter/material.dart";

Widget buildLabel(String text) {
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

Widget buildTextField(TextEditingController controller,
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
      if (value == null || value.isEmpty) {
        return 'Please, fill this field.';
      }
      return null;
    },
  );
}
