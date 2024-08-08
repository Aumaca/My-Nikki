import 'package:flutter_quill/flutter_quill.dart';
import "package:flutter/material.dart";

class CustomQuillEditor extends StatefulWidget {
  final QuillController contentController;

  const CustomQuillEditor({
    super.key,
    required this.contentController,
  });

  @override
  State<CustomQuillEditor> createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
        controller: widget.contentController,
        configurations: const QuillEditorConfigurations(
            customStyles: DefaultStyles(
                color: Colors.white,
                paragraph: DefaultTextBlockStyle(
                    TextStyle(color: Colors.white, fontSize: 16),
                    HorizontalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    null))));
  }
}
