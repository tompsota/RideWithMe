import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ride_with_me/utils/text.dart';

class RideNumberPicker extends StatefulWidget {
  int minValue;
  int maxValue;
  String units;
  bool isEditable;

  RideNumberPicker({Key? key, required this.minValue, required this.maxValue, required this.units, required this.isEditable})
      : super(key: key);

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
                _currentValue.toString() + " " + widget.units,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              if (widget.isEditable) Spacer(),
              if (widget.isEditable) Icon(Icons.edit, color: Colors.grey),
            ],
          ),
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
