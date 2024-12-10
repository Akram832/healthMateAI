import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateInput extends StatelessWidget {
  final Function(DateTime) onDateSelected;
  final String text;

  const MyDateInput({
    Key? key,
    required this.onDateSelected,
    required this.text,
  }) : super(key: key);

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text('DD-MM-YYYY'),
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle: TextStyle(
        color: Color.fromARGB(255, 0, 180, 216),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      onChange: (selectedDate) {
        onDateSelected(selectedDate);
      },
      bottomPickerTheme: BottomPickerTheme.blue,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openDatePicker(context);
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  offset: Offset(1.0, 1.0),
                  blurRadius: 15,
                  spreadRadius: 1.0)
            ],
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(
                    255, 0, 180, 216), // Light blue color for the top
                Color.fromARGB(255, 2, 124, 148), // Ending color (green)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
