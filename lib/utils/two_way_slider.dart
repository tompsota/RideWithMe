import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/utils/callback_types.dart';

import '../controllers/ride_filter_controller.dart';

class TwoWaySlider extends StatelessWidget {
  final RangeValuesCallback callback;
  final RangeValues span;
  final RangeValues initialSpan;
  RangeValues currentValues;
  final String units;

  TwoWaySlider({
    Key? key,
    required this.span,
    required this.initialSpan,
    required this.callback,
    required this.units,
    required this.currentValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: currentValues,
      min: span.start,
      max: span.end,
      divisions: span.end.toInt(),
      labels: RangeLabels(
        currentValues.start.round().toString() + " " + units, //TODO find nicer way to do this
        currentValues.end.round().toString() + " " + units,
      ),
      onChanged: (RangeValues values) {
        callback(values);
      },
    );
  }
}
