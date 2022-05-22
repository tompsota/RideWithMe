import 'package:flutter/material.dart';
import 'package:ride_with_me/models/filter_model.dart';
import 'package:ride_with_me/utils/db/ride.dart';

import '../models/ride_model.dart';


class RideFilterController extends ChangeNotifier {

  final List<RideModel> _allRides = [];
  List<RideModel> get visibleRides => List.unmodifiable(_allRides.where(_appliedFilter.passesFilter));

  Future<void> refreshRides() async {
    // _allRides = await getAllRides();
    final currentRides = await getAllRides();
    _allRides.clear();
    _allRides.addAll(currentRides);
    notifyListeners();
  }

  final FilterModel _currentFilter = FilterModel();
  final FilterModel _appliedFilter = FilterModel();

  void updateDate(DateTime newValue) {
    _currentFilter.selectedDate = newValue;
  }

  void updateStartTime(TimeOfDay newValue) {
    _currentFilter.selectedStartTime = newValue;
  }

  void updateFinishTime(TimeOfDay newValue) {
    _currentFilter.selectedFinishTime = newValue;
  }

  void updateLocation(dynamic newValue) {
    _currentFilter.selectedLocation = newValue;
  }

  void updateDistance(RangeValues newValue) {
    _currentFilter.selectedDistance = newValue;
  }

  void updateClimbing(RangeValues newValue) {
    _currentFilter.selectedClimbing = newValue;
  }

  void updateDuration(RangeValues newValue) {
    _currentFilter.selectedDuration = newValue;
  }

  void updateAvgSpeed(RangeValues newValue) {
    _currentFilter.selectedAvgSpeed = newValue;
  }

  void updateNrParticipants(RangeValues newValue) {
    _currentFilter.selectedNrParticipants = newValue;
  }

  Future<void> applyFilter() async {
    _appliedFilter.update(_currentFilter);
    await refreshRides();
    notifyListeners();
  }

  // resets the current filter to last applied filter (when filter window is closed)
  void resetCurrentFilter() {
    _currentFilter.update(_appliedFilter);
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

  String getFilterLocation() {
    return _appliedFilter.selectedLocation == null ? "" : _appliedFilter.selectedLocation["description"];
  }

  // bool _passesFilter(RideModel ride) => _appliedFilter.passes(ride)
  //   return ride.participantsIds.length >= _appliedFilter.selectedNrParticipants.start
  //     && ride.participantsIds.length <= _appliedFilter.selectedNrParticipants.end;
  // }
}
