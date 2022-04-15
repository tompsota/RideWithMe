import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_with_me/utils/callback_types.dart';

class TimePicker extends StatefulWidget {
  final TimeOfDayCallback callback;
  final TimeOfDay time;

  TimePicker({Key? key, required this.callback, required this.time}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    _selectedTime = widget.time;
  }

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
        child: Text(
          DateFormat.Hm().format(DateFormat.jm().parse(_selectedTime.format(context))),
          style: TextStyle(fontSize: 16),
        ),
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
