import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride_with_me/utils/text.dart';

class RideNumberPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final String units;
  final bool isEditable;
  final ValueChanged<int> callback;
  int currentValue;

  // TODO: change int to double ?

  RideNumberPicker(
      {Key? key,
      required this.minValue,
      required this.maxValue,
      required this.units,
      required this.isEditable,
      required this.callback,
      required this.currentValue})
      : super(key: key);

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
                currentValue.toString() + " " + units,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              if (isEditable) Spacer(),
              if (isEditable) Icon(Icons.edit, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Pick a value")),
            content: StatefulBuilder(builder: (context, builderSetState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                      value: currentValue,
                      minValue: minValue,
                      maxValue: maxValue,
                      onChanged: (value) {
                        currentValue = value; // to change on widget level state
                        builderSetState(() => currentValue = value); //* to change on dialog state
                        callback(currentValue);
                      }),
                  MediumText(units),
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
