import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/callback_types.dart';

class TwoWaySlider extends StatefulWidget {
  final RangeValuesCallback callback;
  final RangeValues span;
  final RangeValues initialSpan;
  final String units;

  TwoWaySlider({
    Key? key,
    required this.span,
    required this.initialSpan,
    required this.callback,
    required this.units,
  }) : super(key: key);

  @override
  _TwoWaySliderState createState() => _TwoWaySliderState();
}

class _TwoWaySliderState extends State<TwoWaySlider> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    _currentRangeValues = widget.initialSpan;
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      min: widget.span.start,
      max: widget.span.end,
      divisions: widget.span.end.toInt(),
      labels: RangeLabels(
        _currentRangeValues.start.round().toString() + " " + widget.units, //TODO find nicer way to do this
        _currentRangeValues.end.round().toString() + " " + widget.units,
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
          widget.callback(_currentRangeValues);
        });
      },
    );
  }
}
