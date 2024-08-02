import 'package:my_nikki/screens/widgets/button.dart';
import 'package:my_nikki/screens/widgets/new_entry/custom_map.dart';
import 'package:my_nikki/screens/widgets/new_entry/quill_toolbar.dart';
import 'package:my_nikki/screens/widgets/new_entry/mood_dropdown.dart';
import 'package:my_nikki/screens/widgets/new_entry/image_slider.dart';
import 'package:my_nikki/screens/widgets/new_entry/quill_editor.dart';
import 'package:my_nikki/screens/widgets/new_entry/custom_map.dart';
import 'package:my_nikki/screens/widgets/date_time_picker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:my_nikki/utils/requests.dart';

class Mood {
  final IconData icon;
  final Color color;

  Mood(this.icon, this.color);
}

class NewEntryForm extends StatefulWidget {
  const NewEntryForm({super.key});

  @override
  State<NewEntryForm> createState() => _NewEntryFormState();
}

class _NewEntryFormState extends State<NewEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('d MMMM, y');
  final QuillController _entryContentController = QuillController.basic();

  DateTime date = DateTime.now().toUtc();
  String? selectedMood;
  List<XFile>? files;

  Future<void> _pickImages() async {
    final List<XFile> selectedMedia =
        await ImagePicker().pickMultipleMedia(limit: 6);
    setState(() {
      files = selectedMedia;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      saveEntry();
    }
  }

  void saveEntry() {
    Map<String, String> data = {
      'content': jsonEncode(_entryContentController.document.toDelta()),
      'mood': selectedMood!,
      'date': date.toIso8601String(),
    };

    genericPost("/entry", data, isAuthenticated: true);

    return;
  }

  void _selectMood(String newMood) {
    setState(() {
      selectedMood = newMood;
    });
  }

  void showMap(BuildContext context, Function(LatLng) onCoordinatesSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            body: CustomMap(onCoordinatesSelected: onCoordinatesSelected));
      },
    );
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
            title: Row(children: [
              Expanded(
                child: GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate =
                          await DateTimePicker(context, date);
                      if (selectedDate != null) {
                        setState(() {
                          date = selectedDate;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          formatter.format(date),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down_rounded,
                            color: Colors.white, size: 32.0),
                      ],
                    )),
              ),
              GestureDetector(
                  onTap: () {
                    _pickImages();
                  },
                  child: const Icon(Icons.attach_file,
                      color: Colors.white, size: 32)),
              MoodPopupMenu(
                onMoodSelected: _selectMood,
              ),
              GestureDetector(
                onTap: () {
                  showMap(context, (coordinates) {
                    Logger().i('Coordinates selected: $coordinates');
                  });
                },
                child: Icon(Icons.pin_drop, color: Colors.red[400], size: 32),
              ),
            ])),
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            // Media
            files != null ? imageSlider(context, files!) : Container(),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  CustomQuillEditor(contentController: _entryContentController),
            )),
            CustomQuillToolbar(contentController: _entryContentController)
          ],
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: customFloatingActionButton(
                saveEntry, Colors.green[400]!, Icons.check)));
  }
}
