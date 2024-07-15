import "package:flutter/material.dart";

void validateAndPass(GlobalKey<FormState> formKey, Function doAction) {
  if (formKey.currentState?.validate() ?? false) {
    doAction();
  }
}
