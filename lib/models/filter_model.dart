import 'package:flutter/material.dart';
import 'package:ride_with_me/models/ride_model.dart';

import '../settings/filter_defaults.dart';

class FilterModel {
  bool selectedAnyDay = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = defaultStartTime;
  TimeOfDay selectedFinishTime = defaultFinishTime;
  dynamic selectedLocation;
  RangeValues selectedDistance = defaultDistance;
  RangeValues selectedClimbing = defaultClimbing;
  RangeValues selectedDuration = defaultDuration;
  RangeValues selectedAvgSpeed = defaultAvgSpeed;
  RangeValues selectedNrParticipants = defaultNrParticipants;

  void reset() {
    selectedAnyDay = false;
    selectedDate = DateTime.now();
    selectedStartTime = defaultStartTime;
    selectedFinishTime = defaultFinishTime;
    selectedLocation = null;
    selectedDistance = defaultDistance;
    selectedClimbing = defaultClimbing;
    selectedDuration = defaultDuration;
    selectedAvgSpeed = defaultAvgSpeed;
    selectedNrParticipants = defaultNrParticipants;
  }

  void update(FilterModel other) {
    selectedAnyDay = other.selectedAnyDay;
    selectedDate = other.selectedDate;
    selectedStartTime = other.selectedStartTime;
    selectedFinishTime = other.selectedFinishTime;
    selectedLocation = other.selectedLocation;
    selectedDistance = other.selectedDistance;
    selectedClimbing = other.selectedClimbing;
    selectedDuration = other.selectedDuration;
    selectedAvgSpeed = other.selectedAvgSpeed;
    selectedNrParticipants = other.selectedNrParticipants;
  }

}
