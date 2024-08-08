import 'package:my_nikki/screens/entries/new_entry.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MoodDropdown extends StatefulWidget {
  final Function(String) onMoodSelected;
  final String? oldMood;
  bool? isReadOnly = false;

  MoodDropdown(
      {super.key, this.isReadOnly, this.oldMood, required this.onMoodSelected});

  @override
  MoodDropdownState createState() => MoodDropdownState();
}

class MoodDropdownState extends State<MoodDropdown> {
  late String _selectedItem;
  late IconData _currentIcon;
  late Color _currentColor;

  Map<String, Mood> moods = {
    'sad': Mood(Icons.sentiment_dissatisfied, MoodColors.sad),
    'neutral': Mood(Icons.sentiment_neutral, MoodColors.neutral),
    'calm': Mood(Icons.sentiment_satisfied, MoodColors.calm),
    'happy': Mood(Icons.sentiment_very_satisfied, MoodColors.happy),
    'excited':
        Mood(Icons.sentiment_very_satisfied_outlined, MoodColors.excited),
  };

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.oldMood != null ? widget.oldMood! : 'neutral';
    _updateCurrentMood();
  }

  void _handleMoodSelection(String? mood) {
    if (mood != null) {
      setState(() {
        _selectedItem = mood;
        _updateCurrentMood();
        widget.onMoodSelected(_selectedItem);
      });
    }
  }

  void _updateCurrentMood() {
    final selectedMood = moods[_selectedItem];
    if (selectedMood != null) {
      _currentIcon = selectedMood.icon;
      _currentColor = selectedMood.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      offset: const Offset(0, 10),
      icon: Icon(_currentIcon, color: _currentColor, size: 32),
      onSelected: _handleMoodSelection,
      color: Colors.white,
      itemBuilder: (BuildContext context) {
        if (widget.isReadOnly == true) {
          return [];
        } else {
          return moods.entries
              .map<PopupMenuEntry<String>>((MapEntry<String, Mood> entry) {
            return PopupMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Icon(entry.value.icon, color: entry.value.color, size: 32),
                  const SizedBox(width: 10),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color.fromRGBO(105, 37, 190, 1),
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        }
      },
    );
  }
}
