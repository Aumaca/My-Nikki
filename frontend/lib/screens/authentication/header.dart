import 'package:flutter/material.dart';
import 'package:my_nikki/utils/colors.dart';

Widget buildHeader(BuildContext context, String title) {
  return Column(
    children: [
      Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width * 1.2,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(200),
            bottomRight: Radius.circular(200),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.book,
                size: 100,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 40),
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 32),
    ],
  );
}
