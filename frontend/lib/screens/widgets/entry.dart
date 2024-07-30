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
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12:00h',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vitae malesuada elit, ut malesuada eros. Donec ut metus mattis urna scelerisque rutrum id.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Icon(
                        Icons.sentiment_satisfied,
                        color: MoodColors.happy,
                      ),
                      SizedBox(width: 8.0),
                      Text(
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
