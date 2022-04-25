import '../models/ride_model.dart';
import '../models/user_model.dart';
import 'db_utils.dart';

Future<RideModel> rideFromJsonFull(Map<String, dynamic> json) async {
  var ride = RideModel.fromJson(json);
  final author = await getUserById(ride.authorId);
  final participants = await getUsersById(ride.participantsIds);
  ride.author = author;
  ride.participants = participants;
  return ride;
}

Future<UserModel> userFromJsonFull(Map<String, dynamic> json) async {
  var user = UserModel.fromJson(json);
  // TODO: getFullRides or getRides ??
  final createdRides = await getRidesByIds(user.createdRidesIds);
  final joinedRides = await getRidesByIds(user.joinedRidesIds);
  final completedRides = await getRidesByIds(user.completedRidesIds);
  user.createdRides = createdRides;
  user.joinedRides = joinedRides;
  user.completedRides = completedRides;
  return user;
}