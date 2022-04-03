import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/callback_types.dart';

class TwoWaySlider extends StatefulWidget {
  RangeValuesCallback callback;
  final double span;

  TwoWaySlider({
    Key? key,
    required this.span,
    required this.callback,
  }) : super(key: key);

  @override
  _TwoWaySliderState createState() => _TwoWaySliderState();
}

class _TwoWaySliderState extends State<TwoWaySlider> {
  // TODO this is ignored, dunno how to fix
  static double _span = 100;

  @override
  void initState() {
    _span = widget.span;
  }

  double get span => widget.span;

  RangeValues _currentRangeValues = RangeValues(0, _span);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      max: _span,
      divisions: _span.toInt(),
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
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
