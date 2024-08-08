import 'package:logger/logger.dart';
import 'package:my_nikki/utils/media.dart';
import 'package:my_nikki/utils/requests.dart';
import "package:flutter/material.dart";
import 'dart:io';

Container imageSlider(BuildContext context, List<Media> media) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    alignment: Alignment.centerLeft,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: media.map((currMedia) {
          int index = media.indexOf(currMedia);
          return GestureDetector(
            onTap: () => showFullScreenImages(context, media, index),
            child: SizedBox(
              width: MediaQuery.of(context).size.width /
                  (media.length < 3 ? media.length : 3),
              child: currMedia.type == MediaType.xfile
                  ? Image.file(
                      File(currMedia.path),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                    )
                  : Image.network(
                      getImage(currMedia.path),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                    ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

void showFullScreenImages(
    BuildContext context, List<Media> media, int initialIndex) {
  showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.7),
        body: fullScreenImageViewer(context, media, initialIndex),
      );
    },
  );
}

Widget fullScreenImageViewer(
    BuildContext context, List<Media> media, int initialIndex) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: PageView.builder(
      itemCount: media.length,
      itemBuilder: (context, index) {
        return Center(
          child: media[index].type == MediaType.xfile
              ? Image.file(
                  File(media[index].path),
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height,
                )
              : Image.network(
                  getImage(media[index].path),
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height,
                ),
        );
      },
      controller: PageController(initialPage: initialIndex),
    ),
  );
}
