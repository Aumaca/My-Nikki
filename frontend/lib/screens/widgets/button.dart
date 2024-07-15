import 'package:flutter/material.dart';

ElevatedButton buildElevatedButton(BuildContext context, void Function() action,
    Color backgroundColor, String buttonText) {
  return ElevatedButton(
    onPressed: action,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    child: Center(
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}
