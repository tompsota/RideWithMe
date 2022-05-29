import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/models/filter_model.dart';
import '../controllers/ride_filter_controller.dart';
import 'callback_types.dart';

class DatePicker extends StatelessWidget {
  final callback;
  final DateTime currentValue;
  final bool isEditable;

  DatePicker({Key? key, required this.callback, required this.currentValue, required this.isEditable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          isEditable ? _selectDate(context) : null;
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          primary: Colors.black,
        ),
        child: Text(
          DateFormat.MMMEd().format(currentValue),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: currentValue, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null) {
      callback(picked);
    }
  }
}
