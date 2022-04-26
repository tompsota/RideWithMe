import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride_with_me/utils/text.dart';

class DurationPicker extends StatefulWidget {
  bool isEditable;
  ValueChanged<Duration> callback;

  DurationPicker({Key? key, required this.isEditable, required this.callback}) : super(key: key);

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int _currentValueHours = 20;
  int _currentValueMins = 20;
  late NumberPicker integerNumberPicker;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: OutlinedButton(
          onPressed: () {
            widget.isEditable ? _showDialog() : null;
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2.0, color: Colors.transparent),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            backgroundColor: Colors.transparent,
            primary: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
            child: Row(
              children: [
                Text(
                  _currentValueHours.toString() + " h   " + _currentValueMins.toString() + " min",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                if (widget.isEditable) Spacer(),
                if (widget.isEditable) Icon(Icons.edit, color: Colors.grey),
              ],
            ),
          ),
        ));
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick a value"),
            content: StatefulBuilder(builder: (context, builderSetState) {
              return Row(
                children: [
                  NumberPicker(
                      value: _currentValueHours,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) {
                        setState(() => _currentValueHours = value); // to change on widget level state
                        builderSetState(() => _currentValueHours = value); //* to change on dialog state
                        widget.callback(Duration(hours: _currentValueHours, minutes: _currentValueMins));
                      }),
                  MediumText("h"),
                  NumberPicker(
                      value: _currentValueMins,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) {
                        setState(() => _currentValueMins = value); // to change on widget level state
                        builderSetState(() => _currentValueMins = value); //* to change on dialog state
                        widget.callback(Duration(hours: _currentValueHours, minutes: _currentValueMins));
                      }),
                  MediumText("min"),
                ],
              );
            }),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
