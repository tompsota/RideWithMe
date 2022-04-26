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

  // TODO: add all conditions
  // might wanna add check for 'COMPLETED' (either attribute or using DateTime.now())
  bool passes(RideModel ride) {
    // return selectedDuration.start <= ride.duration && ride.duration <= selectedDuration.end
    final passesNrParticipants =
        selectedNrParticipants.start <= ride.participantsIds.length &&
        ride.participantsIds.length <= selectedNrParticipants.end;
    print('ride with ${ride.participantsIds.length} participants - passes: $passesNrParticipants');
    return passesNrParticipants;
    // return selectedDistance.start <= ride.distance && ride.distance <= selectedDistance.end;
    // return selectedAvgSpeed.start <= ride.averageSpeed && ride.averageSpeed <= selectedAvgSpeed.end;
  }
}
