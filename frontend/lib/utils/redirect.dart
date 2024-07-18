import "package:flutter/material.dart";

/// Redirect to another named route based in the main.dart
///
/// @toRoute The named route to go. e.g: "/login"
void redirectTo(BuildContext context, String toRoute) {
  if (ModalRoute.of(context)?.settings.name != toRoute) {
    Navigator.pushReplacementNamed(context, toRoute);
  }
}
