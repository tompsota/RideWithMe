import 'package:flutter/material.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import '../models/ride_model.dart';

class NewRideController extends ChangeNotifier {
  // TODO: remove late and add ctor
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
      authorId: "");

  void setRideTitle(String value) {
    ride.title = value;
    notifyListeners();
  }

  void setDuration(Duration value) {
    ride.duration = value;
    notifyListeners();
  }

  void setRideDate(DateTime value) {
    //todo
    notifyListeners();
  }

  void setRideStartTime(TimeOfDay value) {
    //todo
    notifyListeners();
  }

  void setRideMapLink(String value) {
    //todo
    notifyListeners();
  }

  void setRideStartLocation(String value) {
    //todo
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

  void submitRide(String author, UserStateController userController) async {
    ride.authorId = author;
    ride.participantsIds.add(author);
    //todo fix adding ride to db
    // await createRide(ride, userController);
    notifyListeners();
  }

// ride.participants.add(currentUser.id);
}
