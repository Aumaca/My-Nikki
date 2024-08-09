import "package:my_nikki/screens/widgets/entry/home_entry.dart";
import "package:my_nikki/models/user.dart";
import "package:flutter/material.dart";

class HomeEntries extends StatefulWidget {
  final UserModel user;
  final void Function() updateUser;

  const HomeEntries({super.key, required this.user, required this.updateUser});

  @override
  State<HomeEntries> createState() => _HomeEntriesState();
}

class _HomeEntriesState extends State<HomeEntries> {
  late UserModel user;
  late void Function() updateUser;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    updateUser = widget.updateUser;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
            children: user.entries.map((entry) {
          return Column(
            children: [
              const SizedBox(height: 24),
              HomeEntry(
                entryModel: entry,
                updateUser: updateUser,
              ),
            ],
          );
        }).toList()),
      ),
    );
  }
}
