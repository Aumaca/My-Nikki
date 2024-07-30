import 'package:my_nikki/screens/widgets/date_time_picker.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/fields.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:my_nikki/screens/widgets/quill_editor.dart';
import 'package:my_nikki/screens/widgets/quill_toolbar.dart';
import 'package:my_nikki/utils/validate.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewEntryForm extends StatefulWidget {
  const NewEntryForm({super.key});

  @override
  State<NewEntryForm> createState() => _NewEntryFormState();
}

class _NewEntryFormState extends State<NewEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('d MMMM, y');
  final QuillController _entryContentController = QuillController.basic();
  DateTime _date = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      sendToAPI();
    }
  }

  void sendToAPI() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.secondaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await DateTimePicker(context, _date);
                  if (selectedDate != null) {
                    setState(() {
                      _date = selectedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      formatter.format(_date),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down_rounded,
                        color: Colors.white, size: 32.0),
                  ],
                ))),
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  CustomQuillEditor(contentController: _entryContentController),
            )),
            CustomQuillToolbar(contentController: _entryContentController)
          ],
        ));
  }
}
