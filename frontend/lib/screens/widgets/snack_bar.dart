import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color backgroundColor,
    {Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: textColor)),
      duration: duration,
      backgroundColor: backgroundColor,
    ),
  );
}
