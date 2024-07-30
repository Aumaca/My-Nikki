import "package:flutter/material.dart";
import "package:my_nikki/utils/colors.dart";

Future<DateTime?> DateTimePicker(BuildContext context, DateTime initialDate,
    {DateTime? firstDate, DateTime? lastDate}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1950, 1, 1),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.tabBarBackground,
            onPrimary: Colors.white,
            onSurface: AppColors.secondaryColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: AppColors.secondaryColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        child: child!,
      );
    },
  );
}
