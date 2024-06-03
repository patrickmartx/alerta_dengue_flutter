import 'package:flutter/material.dart';

class DatePickerTextField extends StatefulWidget {
  final Function(DateTime) onDateSelected; 

  DatePickerTextField({required this.onDateSelected});

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        widget.onDateSelected(pickedDate); 
      });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () {
        _selectDate(context);
      },
      readOnly: true,
      controller: TextEditingController(
        text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      ),
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
    );
  }
}
