import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_with_me/utils/callback_types.dart';

class TimePicker extends StatefulWidget {
  TimeOfDayCallback callback;

  TimePicker({Key? key, required this.callback}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          _selectTime(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          primary: Colors.black,
        ),
        child: Text(DateFormat.Hm().format(DateFormat.jm().parse(_selectedTime.format(context)))),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      setState(() {
        _selectedTime = timeOfDay;
        widget.callback(_selectedTime);
      });
    }
  }
}
