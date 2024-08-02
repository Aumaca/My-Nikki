import 'package:my_nikki/screens/new_entry/new_entry.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';

class MoodPopupMenu extends StatefulWidget {
  final Function(String) onMoodSelected;

  const MoodPopupMenu({super.key, required this.onMoodSelected});

  @override
  _MoodPopupMenuState createState() => _MoodPopupMenuState();
}

class _MoodPopupMenuState extends State<MoodPopupMenu> {
  String _selectedItem = 'Neutral';
  IconData _currentIcon = Icons.sentiment_neutral;
  Color _currentColor = Colors.yellow;
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
      itemBuilder: (BuildContext context) {
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
      },
    );
  }
}
