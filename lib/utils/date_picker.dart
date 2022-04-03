import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'callback_types.dart';

class DatePicker extends StatefulWidget {
  DateTimeCallback callback;

  DatePicker({Key? key, required this.callback}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          _selectDate(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          primary: Colors.black,
        ),
        child: Text(DateFormat.MMMEd().format(_selectedDate)),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.callback(_selectedDate);
      });
    }
  }
}
