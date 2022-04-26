import 'package:flutter/material.dart';
import 'package:ride_with_me/models/filter_model.dart';

class RideFilterController extends ChangeNotifier {
  final FilterModel _currentFilter = FilterModel();
  final FilterModel _appliedFilter = FilterModel();

  void updateDate(DateTime newValue) {
    _currentFilter.selectedDate = newValue;
    // notifyListeners();
  }

  void updateStartTime(TimeOfDay newValue) {
    _currentFilter.selectedStartTime = newValue;
    // notifyListeners();
  }

  void updateFinishTime(TimeOfDay newValue) {
    _currentFilter.selectedFinishTime = newValue;
    // notifyListeners();
  }

  void updateLocation(dynamic newValue) {
    _currentFilter.selectedLocation = newValue;
    // notifyListeners();
  }

  void updateDistance(RangeValues newValue) {
    _currentFilter.selectedDistance = newValue;
    // notifyListeners();
  }

  void updateClimbing(RangeValues newValue) {
    _currentFilter.selectedClimbing = newValue;
    // notifyListeners();
  }

  void updateDuration(RangeValues newValue) {
    _currentFilter.selectedDuration = newValue;
    // notifyListeners();
  }

  void updateAvgSpeed(RangeValues newValue) {
    _currentFilter.selectedAvgSpeed = newValue;
    // notifyListeners();
  }

  // TODO: commented out all the notifyListeners() in these updateXYZ methods
  void updateNrParticipants(RangeValues newValue) {
    _currentFilter.selectedNrParticipants = newValue;
    // notifyListeners();
  }

  // TODO: shouldn't notifyListeners() be only here and in resetFilters() ?
  // otherwise we reload the Consumer widget with every update
  void applyFilter() {
    _appliedFilter.update(_currentFilter);
    print('applies filter: $_appliedFilter');
    notifyListeners();
  }

  // resets the current filter to last applied filter (when filter window is closed)
  void resetCurrentFilter() {
    _currentFilter.update(_appliedFilter);
  }

  //reset filters to default values
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
}
