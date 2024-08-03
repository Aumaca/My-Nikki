import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
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
                  const Text(
                    '12:00h',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vitae malesuada elit, ut malesuada eros. Donec ut metus mattis urna scelerisque rutrum id.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Icon(
                        Icons.sentiment_satisfied,
                        color: MoodColors.happy,
                      ),
                      const SizedBox(width: 8.0),
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
        ));
  }
}
