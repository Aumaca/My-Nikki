import 'package:intl/intl.dart';
import 'package:my_nikki/models/entry.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeEntry extends StatefulWidget {
  final EntryModel entryModel;
  final void Function() updateUser;

  const HomeEntry(
      {super.key, required this.entryModel, required this.updateUser});

  @override
  State<HomeEntry> createState() => _HomeEntryState();
}

class _HomeEntryState extends State<HomeEntry> {
  @override
  Widget build(BuildContext context) {
    EntryModel entry = widget.entryModel;

    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, "/entry",
            arguments: {"entry": entry, "updateUser": widget.updateUser}),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                // Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16.0)),
                ),

                const SizedBox(width: 16.0),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Text(
                        DateFormat('d MMMM, y').format(entry.date),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),

                      const SizedBox(height: 6.0),

                      // Content
                      Text(
                        entry.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 12.0),

                      // Icon and localization
                      Row(
                        children: [
                          // Icon
                          Icon(
                            Icons.sentiment_satisfied,
                            color: MoodColors.happy,
                          ),

                          const SizedBox(width: 8.0),

                          // Localization
                          const Text(
                            'Rua xxx, yyyy',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
