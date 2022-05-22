import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/models/ride_model.dart';
import 'package:ride_with_me/models/user_model.dart';
import 'package:ride_with_me/utils/db/user.dart';
import 'package:ride_with_me/utils/db/from_json.dart';


Future<RideModel?> getFullRideById(String id) async {
  final rideSnapshot = await FirebaseFirestore.instance.collection('rides').doc(id).get();
  if (rideSnapshot.exists) {
    final ride = RideModel.fromJson(rideSnapshot.data()!);
    return getFullRide(ride);
  } else {
    return null;
  }
}

Future<List<RideModel>> getAllRides() async {
  final rideSnapshots = await FirebaseFirestore.instance.collection('rides').get();
  return rideSnapshots.docs.map((doc) => RideModel.fromJson(doc.data())).toList();
}

Future<List<RideModel>> getRidesByIds(List<String> ids) async {
  final rideSnapshots = await FirebaseFirestore.instance.collection('rides').get();
  final filteredDocs = rideSnapshots.docs.where((doc) => ids.contains(doc.id));
  return filteredDocs.map((doc) => RideModel.fromJson(doc.data())).toList();
}

Future<List<RideModel>> getRidesWithAuthorByIds(List<String> ids) async {
  final rideSnapshots = await FirebaseFirestore.instance.collection('rides').get();
  final filteredDocs = rideSnapshots.docs.where((doc) => ids.contains(doc.id));
  return await Future.wait(filteredDocs.map((doc) async => await rideFromJsonWithAuthor(doc.data())).toList());
}

Future<List<RideModel>> getFullRidesByIds(List<String> ids) async {
  final rideSnapshots = await FirebaseFirestore.instance.collection('rides').get();
  final filteredDocs = rideSnapshots.docs.where((doc) => ids.contains(doc.id));
  return await Future.wait(filteredDocs.map((doc) async => await rideFromJsonFull(doc.data())).toList());
}

Future<void> createRide(RideModel ride, UserStateController userController) async {
  final user = userController.user;
  var updatedCreatedRidesIds = user.createdRidesIds;
  updatedCreatedRidesIds.add(ride.id);
  UserModel updatedUser = UserModel(
    lastName: user.lastName,
    firstName: user.firstName,
    email: user.email,
    aboutMe: user.aboutMe,
    createdRidesIds: updatedCreatedRidesIds,
    completedRidesIds: user.completedRidesIds,
    joinedRidesIds: user.joinedRidesIds,
    avatarURL: user.avatarURL,
  );
  userController.addCreatedRide(ride.id);
  await updateUser(user.getId(), updatedUser);

  final rides = FirebaseFirestore.instance.collection('rides');
  return rides
      .doc(ride.id)
      .set(ride.toJson())
      .then((value) => print("Ride added - ${ride.title} by ${userController.user.email}."))
      .catchError((error) => print("Failed to add ride - ${ride.title} by ${userController.user.email}: $error"));
}

// add userId to ride.participantsIds
// add rideId to user.joinedRides
Future<void> joinRide(RideModel ride, UserStateController userController) async {
  final user = userController.user;
  var updatedRidesIds = user.joinedRidesIds;
  updatedRidesIds.add(ride.id);
  final updatedUser = UserModel(
    lastName: user.lastName,
    firstName: user.firstName,
    email: user.email,
    aboutMe: user.aboutMe,
    createdRidesIds: user.createdRidesIds,
    completedRidesIds: user.completedRidesIds,
    joinedRidesIds: updatedRidesIds,
    avatarURL: user.avatarURL,
  );
  // userController.addCreatedRide(ride.id);
  await updateUser(user.getId(), updatedUser);

  var updatedParticipantsIds = ride.participantsIds;
  updatedParticipantsIds.add(user.getId());
  final updatedRide = RideModel(
      participantsIds: updatedParticipantsIds,
      isCompleted: ride.isCompleted,
      title: ride.title,
      authorId: ride.authorId,
      id: ride.id,
      climbing: ride.climbing,
      duration: ride.duration,
      distance: ride.distance,
      averageSpeed: ride.averageSpeed,
      createdAt: ride.createdAt,
      tags: ride.tags
  );
  await updateRide(updatedRide.id, updatedRide);
}

// remove userId from ride.participantsIds
// remove rideId from user.joinedRides
Future<void> leaveRide(RideModel ride, UserStateController userController) async {
  final user = userController.user;
  var updatedRidesIds = user.joinedRidesIds;
  updatedRidesIds.remove(ride.id);
  final updatedUser = UserModel(
    lastName: user.lastName,
    firstName: user.firstName,
    email: user.email,
    aboutMe: user.aboutMe,
    createdRidesIds: user.createdRidesIds,
    completedRidesIds: user.completedRidesIds,
    joinedRidesIds: updatedRidesIds,
    avatarURL: user.avatarURL,
  );
  await updateUser(user.getId(), updatedUser);

  var updatedParticipantsIds = ride.participantsIds;
  updatedParticipantsIds.remove(user.getId());
  final updatedRide = RideModel(
      participantsIds: updatedParticipantsIds,
      isCompleted: ride.isCompleted,
      title: ride.title,
      authorId: ride.authorId,
      id: ride.id,
      climbing: ride.climbing,
      duration: ride.duration,
      distance: ride.distance,
      averageSpeed: ride.averageSpeed,
      createdAt: ride.createdAt,
      tags: ride.tags
  );
  await updateRide(updatedRide.id, updatedRide);
}

// >> mark ride as completed
// set ride.isCompleted to true
// for each participant:
//   - remove rideId from user.joinedRides
//   - add rideId to user.completedRides
// TODO: could directly update UserStateController.user.completedRides
Future<void> completeRide(RideModel ride) async {
  final updatedRide = RideModel(
      participantsIds: ride.participantsIds,
      isCompleted: true,
      title: ride.title,
      authorId: ride.authorId,
      id: ride.id,
      climbing: ride.climbing,
      duration: ride.duration,
      distance: ride.distance,
      averageSpeed: ride.averageSpeed,
      createdAt: ride.createdAt,
      tags: ride.tags
  );
  await updateRide(updatedRide.id, updatedRide);

  ride.participants.forEach((user) async {
    var updatedJoinedRidesIds = user.joinedRidesIds;
    updatedJoinedRidesIds.remove(ride.id);
    var updatedCompletedRidesIds = user.completedRidesIds;
    updatedCompletedRidesIds.add(ride.id);

    final updatedUser = UserModel(
      lastName: user.lastName,
      firstName: user.firstName,
      email: user.email,
      aboutMe: user.aboutMe,
      avatarURL: user.avatarURL,
      createdRidesIds: user.createdRidesIds,
      completedRidesIds: updatedCompletedRidesIds,
      joinedRidesIds: updatedJoinedRidesIds,
    );
    await updateUser(user.getId(), updatedUser);
  });
}

Future<RideModel?> getFullRide(RideModel? ride) async {
  if (ride == null) {
    return null;
  }
  ride.author = await getUserById(ride.authorId);
  ride.participants = await getUsersById(ride.participantsIds);
  return ride;
}

Future<RideModel> getRideWithAuthor(RideModel ride) async {
  ride.author = await getUserById(ride.authorId);
  return ride;
}