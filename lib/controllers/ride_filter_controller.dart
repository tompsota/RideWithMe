import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ride_with_me/models/filter_model.dart';
import 'package:ride_with_me/utils/db/ride.dart';

import '../models/ride_model.dart';


class RideFilterController extends ChangeNotifier {

  // final List<RideModel> _allRides = [];
  // List<RideModel> get visibleRides => List.unmodifiable(_allRides.where(_appliedFilter.passesFilter));
  // List<RideModel> filteredRides = [];
  //
  // Future<void> refreshRides() async {
  //   // _allRides = await getAllRides();
  //   // TODO: remove after testing
  //   // await Future.delayed(Duration(seconds: 1));
  //   // sleep(Duration(seconds:1));
  //   final currentRides = await getAllRides();
  //   _allRides.clear();
  //   _allRides.addAll(currentRides);
  //   // print('refresh: ${_allRides.length}');
  //   // filteredRides = _allRides.where(_appliedFilter.passesFilter).toList();
  //   // print('refresh - all rides: ${_allRides.length}');
  //   // print('refresh - filtered rides: ${filteredRides.length}');
  //   notifyListeners();
  // }

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

  FilterModel getAppliedFilter() {
    return _appliedFilter;
  }

  FilterModel getCurrentFilter() {
    return _currentFilter;
  }

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
