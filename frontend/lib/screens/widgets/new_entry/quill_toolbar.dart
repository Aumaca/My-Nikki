import 'package:flutter_quill/flutter_quill.dart';
import "package:flutter/material.dart";

class CustomQuillToolbar extends StatefulWidget {
  final QuillController contentController;

  const CustomQuillToolbar({
    super.key,
    required this.contentController,
  });

  @override
  State<CustomQuillToolbar> createState() => _CustomQuillToolbarState();
}

class _CustomQuillToolbarState extends State<CustomQuillToolbar> {
  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
        controller: widget.contentController,
        configurations:
            const QuillSimpleToolbarConfigurations(multiRowsDisplay: false));
  }
}
