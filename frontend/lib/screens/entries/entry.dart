import 'package:my_nikki/utils/media.dart';
import 'package:my_nikki/screens/widgets/entry/quill_toolbar.dart';
import 'package:my_nikki/screens/widgets/entry/mood_dropdown.dart';
import 'package:my_nikki/screens/widgets/entry/quill_editor.dart';
import 'package:my_nikki/screens/widgets/entry/image_slider.dart';
import 'package:my_nikki/screens/widgets/entry/custom_map.dart';
import 'package:my_nikki/screens/widgets/date_time_picker.dart';
import 'package:my_nikki/screens/widgets/snack_bar.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_nikki/utils/requests.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:my_nikki/models/entry.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Mood {
  final IconData icon;
  final Color color;

  Mood(this.icon, this.color);
}

class Entry extends StatefulWidget {
  final void Function() updateUser;
  final EntryModel entry;

  const Entry({super.key, required this.updateUser, required this.entry});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  final DateFormat formatter = DateFormat('d MMMM, y');
  bool isReadOnly = true;

  late DateTime date;
  late EntryModel entry;
  late List<Media> media;
  late String selectedMood;
  late LatLng? localization;
  late QuillController entryContentController;

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
    date = entry.date;
    selectedMood = entry.mood;
    localization = entry.localization;

    // Media
    media = entry.media
        .map((currMedia) =>
            Media(type: MediaType.backend, path: currMedia.toString()))
        .toList();

    // Content
    final content =
        Document.fromJson(jsonDecode(entry.content) as List<dynamic>);
    entryContentController = QuillController(
        document: content,
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: isReadOnly);
  }

  void saveEntry() async {
    if (entryContentController.document.toPlainText().trim().isEmpty) {
      showSnackBar(context, "Entry's text is empty.", Colors.red[400]!);
      return;
    }

    Map<String, dynamic> data = {
      'content': jsonEncode(entryContentController.document.toDelta()),
      'mood': entry.mood,
      'date': entry.date.toIso8601String(),
      'localization': entry.localization,
      'tags': entry.tags,
    };

    Response response =
        await genericPostEntry("/entry", data, isAuthenticated: true);
    if (response.statusCode == 201) {
      widget.updateUser();
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      Logger().e("Error saving entry");
    }

    return;
  }

  Future<void> _pickImages() async {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final List<XFile>? selectedMedias =
        await ImagePicker().pickMultipleMedia(limit: 6);
    if (selectedMedias != null) {
      List<Media> filesToMedia = selectedMedias
          .map(
              (currMedia) => Media(type: MediaType.xfile, path: currMedia.path))
          .toList();

      setState(() {
        media.addAll(filesToMedia);
      });
    }
  }

  void selectLocalization(LatLng coordinates) {
    setState(() {
      localization = coordinates;
    });
  }

  void selectMood(String newMood) {
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
            body: CustomMap(
                initialCoordinates: localization,
                onCoordinatesSelected: onCoordinatesSelected));
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
                          await dateTimePicker(context, date);
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
              MoodDropdown(
                onMoodSelected: selectMood,
              ),
              GestureDetector(
                onTap: () {
                  showMap(context, selectLocalization);
                },
                child: Icon(Icons.pin_drop, color: Colors.red[400], size: 32),
              ),
            ])),
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            (media.isNotEmpty) ? imageSlider(context, media) : Container(),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  CustomQuillEditor(contentController: entryContentController),
            )),
            (!isReadOnly
                ? CustomQuillToolbar(
                    contentController: entryContentController,
                  )
                : Container())
          ],
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: customFloatingActionButton(
                saveEntry, Colors.green[400]!, Icons.check)));
  }
}
