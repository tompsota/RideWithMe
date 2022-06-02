import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/ride_filter_controller.dart';
import '../domain_layer/models/filter_model.dart';
import '../settings/filter_defaults.dart';
import '../utils/text.dart';
import '../utils/two_way_slider.dart';

class FilterRangeSliders extends StatelessWidget {
  const FilterRangeSliders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RideFilterController _rideFilterProvider = Provider.of<RideFilterController>(context, listen: false);
    FilterModel _appliedFilter = _rideFilterProvider.appliedFilter;

    return Consumer<RideFilterController>(
      builder: (context, filterModel, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          MediumText("Distance"),
          TwoWaySlider(
            span: defaultDistance,
            initialSpan: _appliedFilter.selectedDistance,
            callback: (range) => _rideFilterProvider.updateDistance(range),
            units: "km",
            currentValues: filterModel.currentFilter.selectedDistance,
          ),
          SizedBox(height: 20),
          MediumText("Climbing"),
          TwoWaySlider(
            span: defaultClimbing,
            initialSpan: _appliedFilter.selectedClimbing,
            callback: (range) => _rideFilterProvider.updateClimbing(range),
            units: "m",
            currentValues: filterModel.currentFilter.selectedClimbing,
          ),
          SizedBox(height: 20),
          MediumText("Duration"),
          TwoWaySlider(
            span: defaultDuration,
            initialSpan: _appliedFilter.selectedDuration,
            callback: (range) => _rideFilterProvider.updateDuration(range),
            units: "h",
            currentValues: filterModel.currentFilter.selectedDuration,
          ),
          SizedBox(height: 20),
          MediumText("Expected average speed"),
          TwoWaySlider(
            span: defaultAvgSpeed,
            initialSpan: _appliedFilter.selectedAvgSpeed,
            callback: (range) => _rideFilterProvider.updateAvgSpeed(range),
            units: "km/h",
            currentValues: filterModel.currentFilter.selectedAvgSpeed,
          ),
          SizedBox(height: 20),
          MediumText("Participants"),
          TwoWaySlider(
            span: defaultNrParticipants,
            initialSpan: _appliedFilter.selectedNrParticipants,
            callback: (range) => _rideFilterProvider.updateNrParticipants(range),
            units: "",
            currentValues: filterModel.currentFilter.selectedNrParticipants,
          ),
        ],
      ),
    );
  }
}
