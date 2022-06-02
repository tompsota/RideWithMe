import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ride_with_me/domain_layer/models/filter_model.dart';
import 'package:ride_with_me/utils/db/ride.dart';

import '../domain_layer/models/ride_model.dart';


class RideFilterController extends ChangeNotifier {

  final FilterModel _currentFilter = FilterModel();
  final FilterModel _appliedFilter = FilterModel();

  void updateDate(DateTime newValue) {
    _currentFilter.selectedDate = newValue;
    notifyListeners();
  }

  void updateStartTime(TimeOfDay newValue) {
    _currentFilter.selectedStartTime = newValue;
    notifyListeners();
  }

  void updateFinishTime(TimeOfDay newValue) {
    _currentFilter.selectedFinishTime = newValue;
    notifyListeners();
  }

  void updateLocation(String newValue) {
    _currentFilter.selectedLocation = newValue;
    notifyListeners();
  }

  void updateDistance(RangeValues newValue) {
    _currentFilter.selectedDistance = newValue;
    notifyListeners();
  }

  void updateClimbing(RangeValues newValue) {
    _currentFilter.selectedClimbing = newValue;
    notifyListeners();
  }

  void updateDuration(RangeValues newValue) {
    _currentFilter.selectedDuration = newValue;
    notifyListeners();
  }

  void updateAvgSpeed(RangeValues newValue) {
    _currentFilter.selectedAvgSpeed = newValue;
    notifyListeners();
  }

  void updateNrParticipants(RangeValues newValue) {
    _currentFilter.selectedNrParticipants = newValue;
    notifyListeners();
  }

  Future<void> applyFilter() async {
    _appliedFilter.update(_currentFilter);
    // await refreshRides();
    notifyListeners();
  }

  // resets the current filter to last applied filter (when filter window is closed)
  void resetCurrentFilter() {
    _currentFilter.update(_appliedFilter);
    notifyListeners();
  }

  // resets filters to default values
  void resetFilters() {
    _currentFilter.reset();
    _appliedFilter.reset();
    notifyListeners();
  }

  FilterModel get appliedFilter => _appliedFilter;
  FilterModel get currentFilter => _currentFilter;

  // TODO: use getters instead of getX()

  DateTime getCurrentFilterDate() {
    return _currentFilter.selectedDate;
  }

  String getFilterLocation() {
    return _appliedFilter.selectedLocation == null ? "" : _appliedFilter.selectedLocation;
  }

  // bool _passesFilter(RideModel ride) => _appliedFilter.passes(ride)
  //   return ride.participantsIds.length >= _appliedFilter.selectedNrParticipants.start
  //     && ride.participantsIds.length <= _appliedFilter.selectedNrParticipants.end;
  // }
}
