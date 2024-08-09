import "package:my_nikki/screens/widgets/entry/home_entry.dart";
import "package:my_nikki/utils/requests.dart";
import "package:my_nikki/models/entry.dart";
import "package:my_nikki/utils/media.dart";
import "package:my_nikki/models/user.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";

class HomeMedias extends StatefulWidget {
  final UserModel user;
  final void Function() updateUser;

  const HomeMedias({
    super.key,
    required this.user,
    required this.updateUser,
  });

  @override
  State<HomeMedias> createState() => _HomeMediasState();
}

class _HomeMediasState extends State<HomeMedias> {
  late UserModel user;
  late void Function() updateUser;
  List<Media> medias = [];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    updateUser = widget.updateUser;

    if (user.media.isNotEmpty) {
      for (List<dynamic> currMedia in user.media) {
        medias.add(Media(
            path: currMedia[0],
            entryID: currMedia[1],
            type: MediaType.backend));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: medias.length,
        itemBuilder: (context, index) {
          Media currMedia = medias[index];
          return GestureDetector(
            onTap: () {
              EntryModel currEntry = user.entries.firstWhere(
                  (currEntryItem) => currEntryItem.id == currMedia.entryID);
              Navigator.pushNamed(context, "/entry",
                  arguments: {"entry": currEntry, "updateUser": updateUser});
              return;
            },
            child: Image.network(getImage(currMedia.path), fit: BoxFit.cover),
          );
        });
  }
}
