import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride_with_me/utils/text.dart';

class RideNumberPicker extends StatefulWidget {
  int minValue;
  int maxValue;
  String units;

  RideNumberPicker({Key? key, required this.minValue, required this.maxValue, required this.units}) : super(key: key);

  @override
  State<RideNumberPicker> createState() => _RideNumberPickerState();
}

class _RideNumberPickerState extends State<RideNumberPicker> {
  int _currentValue = 20;
  late NumberPicker integerNumberPicker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: () {
          _showDialog();
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          primary: Colors.black,
        ),
        child: Text(
          _currentValue.toString() + " " + widget.units,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void _showDialog() {
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
                      value: _currentValue,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      onChanged: (value) {
                        setState(() => _currentValue = value); // to change on widget level state
                        builderSetState(() => _currentValue = value); //* to change on dialog state
                      }),
                  MediumText(widget.units),
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
