import 'package:flutter/material.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/domain_layer/repositories/db_repository.dart';
import 'package:ride_with_me/domain_layer/repositories/rides_repository.dart';
import '../domain_layer/models/ride_model.dart';

class NewRideController extends ChangeNotifier {

  NewRideController({required this.ridesRepository});

  final RidesRepository ridesRepository;

  RideModel ride = RideModel.id(
    createdAt: DateTime.now(),
    averageSpeed: 0,
    distance: 0,
    climbing: 0,
    duration: Duration(),
    tags: [],
    participantsIds: [],
    isCompleted: false,
    title: "",
    authorId: "",
    rideMapLink: '',
    rideStartLocationName: '',
    rideDate: DateTime.now(),
    rideStartTime: "0:0",
  );

  void setRideTitle(String value) {
    ride.title = value;
    notifyListeners();
  }

  void setDuration(Duration value) {
    ride.duration = value;
    notifyListeners();
  }

  void setRideDate(DateTime value) {
    ride.rideDate = value;
    notifyListeners();
  }

  void setRideStartTime(TimeOfDay value) {
    ride.rideStartTime = '${value.hour.toString()}:${value.minute.toString()}';
    notifyListeners();
  }

  void setRideMapLink(String value) {
    ride.rideMapLink = value;
    notifyListeners();
  }

  void setRideStartLocation(String value) {
    ride.rideStartLocationName = value;
    notifyListeners();
  }

  void setRideDistance(int value) {
    ride.distance = value;
    notifyListeners();
  }

  void setRideAvgSpeed(int value) {
    ride.averageSpeed = value;
    notifyListeners();
  }

  void setRideClimbing(int value) {
    ride.climbing = value;
    notifyListeners();
  }

  void setRideTags(List<String> value) {
    ride.tags = value;
    notifyListeners();
  }

  Future<void> submitRide(String authorId) async {
    ride.authorId = authorId;
    ride.participantsIds = [authorId];
    await ridesRepository.createRide(ride);
  }
}
