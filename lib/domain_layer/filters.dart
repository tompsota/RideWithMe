import 'package:flutter/material.dart';

import 'models/filter_model.dart';
import 'models/ride_model.dart';
import 'models/user_model.dart';


typedef UserModelFilter = bool Function(UserModel user);
typedef RideModelFilter = bool Function(RideModel ride);


/// Class for defining filters that operate on models.
class Filters {

  /// Used for filtering ride's participants.
  static UserModelFilter isParticipant(RideModel ride) {
    return (UserModel user) => ride.participantsIds.contains(user.id);
  }

  /// Can be used to filter a singular user with given id.
  static UserModelFilter userHasGivenId(String id) {
    return (UserModel user) => user.id == id;
  }

  /// Used for filtering rides with given id's, e.g. user's joined rides.
  static RideModelFilter isRideFromCollection(List<String> ridesIds) {
    return (RideModel ride) => ridesIds.contains(ride.id);
  }

  /// Used for filtering rides based on a filter specified by the user.
  static RideModelFilter passesRidesFilter(FilterModel filter) {
    return (RideModel ride) {
      final passesNrParticipants = _passesRange(filter.selectedNrParticipants, ride.participantsIds.length);
      final passesDistance = _passesRange(filter.selectedDistance, ride.distance);
      final passesClimbing = _passesRange(filter.selectedClimbing, ride.climbing);
      final passesAvgSpeed = _passesRange(filter.selectedAvgSpeed, ride.averageSpeed);

      // TODO: add filtering by day? (start - finish)
      // final passesStartFinishTimes = ride.startTime => selectedStartTime && ride.startTime <= selectedFinishTime;
      // final passesDuration

      // TODO: add location filtering - only equals or also contains etc.?
      final passesLocation = filter.selectedLocation == ride.rideStartLocationName;

      final passesList = [
        passesNrParticipants,
        passesAvgSpeed,
        passesDistance,
        passesClimbing
      ];

      return passesList.every((x) => x);
    };
  }

  static bool _passesRange(RangeValues filterRange, int rideValue) {
    return rideValue >= filterRange.start && rideValue <= filterRange.end;
  }
}