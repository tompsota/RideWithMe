import 'package:flutter/material.dart';

import 'models/filter_model.dart';
import 'models/ride_model.dart';
import 'models/user_model.dart';


typedef UserModelFilter = bool Function(UserModel user);
typedef RideModelFilter = bool Function(RideModel ride);

class Filters {

  static UserModelFilter isParticipant(RideModel ride) {
    return (UserModel user) => ride.participantsIds.contains(user.id);
  }

  static UserModelFilter userHasGivenId(String id) {
    return (UserModel user) => user.id == id;
  }

  static RideModelFilter isRideFromCollection(List<String> ridesIds) {
    return (RideModel ride) => ridesIds.contains(ride.id);
  }

  static RideModelFilter passesRidesFilter(FilterModel filter) {
    return (RideModel ride) {
      final passesNrParticipants = _passesRange(filter.selectedNrParticipants, ride.participantsIds.length);
      final passesDistance = _passesRange(filter.selectedDistance, ride.distance);
      final passesClimbing = _passesRange(filter.selectedClimbing, ride.climbing);
      // final passesDuration = _passesRange(selectedDuration, ride.duration);
      final passesAvgSpeed = _passesRange(filter.selectedAvgSpeed, ride.averageSpeed);
      // final passesStartFinishTimes = ride.startTime => selectedStartTime && ride.startTime <= selectedFinishTime;

      // TODO: add this condition ?
      final passesLocation = filter.selectedLocation == ride.rideStartLocationName;

      final passesList = [
        passesNrParticipants,
        passesAvgSpeed,
        passesDistance,
        passesClimbing
        // passesDuration
      ];
      // print(passesList);
      final passes = passesList.every((x) => x);
      // print('Passes: $passes');
      return passes;
    };
  }

  // what about double accuracy?
  // check: https://pub.dev/documentation/dart_numerics/latest/dart_numerics/almostEqualNumbersBetween.html
  static bool _passesRange(RangeValues filterRange, dynamic rideValue) {
    return rideValue >= filterRange.start && rideValue <= filterRange.end;
  }
}