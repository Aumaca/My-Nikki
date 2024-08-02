import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";
import 'dart:io';

Container imageSlider(BuildContext context, List<XFile> files) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    alignment: Alignment.centerLeft,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: files.map((file) {
          int index = files.indexOf(file);
          return GestureDetector(
            onTap: () => showFullScreenImages(context, files, index),
            child: Container(
              width: MediaQuery.of(context).size.width /
                  (files.length < 3 ? files.length : 3),
              child: Image.file(
                File(file.path),
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
    BuildContext context, List<XFile> files, int initialIndex) {
  showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.7),
        body: fullScreenImageViewer(context, files, initialIndex),
      );
    },
  );
}

Widget fullScreenImageViewer(
    BuildContext context, List<XFile> imageFiles, int initialIndex) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: GestureDetector(
      child: PageView.builder(
        itemCount: imageFiles.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.file(
              File(imageFiles[index].path),
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height,
            ),
          );
        },
        controller: PageController(initialPage: initialIndex),
      ),
    ),
  );
}
