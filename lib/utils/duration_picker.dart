import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride_with_me/utils/text.dart';

class DurationPicker extends StatelessWidget {
  bool isEditable;
  ValueChanged<Duration> callback;
  Duration currentValue;

  DurationPicker({Key? key, required this.isEditable, required this.callback, required this.currentValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: OutlinedButton(
          onPressed: () {
            isEditable ? _showDialog(context) : null;
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
                  currentValue.inHours.toString() + " h   " + currentValue.inMinutes.remainder(60).toString() + " min",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                if (isEditable) Spacer(),
                if (isEditable) Icon(Icons.edit, color: Colors.grey),
              ],
            ),
          ),
        ));
  }

  void _showDialog(BuildContext context) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick a value"),
            content: StatefulBuilder(builder: (context, builderSetState) {
              return Row(
                children: [
                  NumberPicker(
                      value: currentValue.inHours,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) {
                        currentValue = Duration(hours: value, minutes: currentValue.inMinutes.remainder(60));
                        builderSetState(
                            () => Duration(hours: value, minutes: currentValue.inMinutes.remainder(60))); //* to change on dialog state
                        callback(Duration(hours: value, minutes: currentValue.inMinutes.remainder(60)));
                      }),
                  MediumText("h"),
                  NumberPicker(
                      value: currentValue.inMinutes.remainder(60),
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) {
                        currentValue = Duration(hours: currentValue.inHours, minutes: value);
                        builderSetState(() => Duration(hours: currentValue.inHours, minutes: value)); //* to change on dialog state
                        callback(Duration(hours: currentValue.inHours, minutes: value));
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
