import 'package:flutter/material.dart';

class RideFilter extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedFinishTime = TimeOfDay.now();
  dynamic _selectedLocation;
  RangeValues _selectedDistance = RangeValues(0, 1);
  RangeValues _selectedClimbing = RangeValues(0, 1);
  RangeValues _selectedDuration = RangeValues(0, 1);
  RangeValues _selectedAvgSpeed = RangeValues(0, 1);
  RangeValues _selectedNrParticipants = RangeValues(0, 1);

  void updateDate(DateTime newValue) {
    _selectedDate = newValue;
    notifyListeners();
  }

  void updateStartTime(TimeOfDay newValue) {
    _selectedStartTime = newValue;
    notifyListeners();
  }

  void updateFinishTime(TimeOfDay newValue) {
    _selectedFinishTime = newValue;
    notifyListeners();
  }

  void updateLocation(dynamic newValue) {
    _selectedLocation = newValue;
    notifyListeners();
  }

  void updateDistance(RangeValues newValue) {
    _selectedDistance = newValue;
    notifyListeners();
  }

  void updateClimbing(RangeValues newValue) {
    _selectedClimbing = newValue;
    notifyListeners();
  }

  void updateDuration(RangeValues newValue) {
    _selectedDuration = newValue;
    notifyListeners();
  }

  void updateAvgSpeed(RangeValues newValue) {
    _selectedAvgSpeed = newValue;
    notifyListeners();
  }

  void updateNrParticipants(RangeValues newValue) {
    _selectedNrParticipants = newValue;
    notifyListeners();
  }
}
