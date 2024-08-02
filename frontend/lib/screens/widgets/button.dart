import 'package:flutter/material.dart';

ElevatedButton buildElevatedButton(
    BuildContext context, void Function() action, Color backgroundColor,
    {String? text, IconData? icon}) {
  return ElevatedButton(
    onPressed: action,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    child: Center(
      child: text != null
          ? Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )
          : Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
    ),
  );
}

FloatingActionButton customFloatingActionButton(
    void Function() action, Color backgroundColor, IconData icon) {
  return FloatingActionButton(
    onPressed: action,
    backgroundColor: backgroundColor,
    child: Icon(
      icon,
      color: Colors.white,
      size: 32,
    ),
  );
}
