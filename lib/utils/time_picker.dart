import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatelessWidget {
  final callback;
  final TimeOfDay time;
  bool isEditable;

  TimePicker({Key? key, required this.callback, required this.time, required this.isEditable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          isEditable ? _selectTime(context) : null;
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          primary: Colors.black,
        ),
        child: Text(
          DateFormat.Hm().format(DateFormat.jm().parse(time.format(context))),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      callback(timeOfDay);
    }
  }
}
