import "package:flutter/material.dart";

Widget buildDropdown(
    String selectedItem, ValueChanged<String?> onChange, List<String> items) {
  return DropdownButtonFormField<String>(
    value: selectedItem,
    onChanged: onChange,
    items: items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color.fromRGBO(105, 37, 190, 1),
          ),
        ),
      );
    }).toList(),
    decoration: const InputDecoration(
      fillColor: Color.fromRGBO(211, 211, 211, 1),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
