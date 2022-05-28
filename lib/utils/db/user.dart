import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/models/ride_model.dart';
import 'package:ride_with_me/models/user_model.dart';
import 'package:ride_with_me/utils/db/ride.dart';


Future<UserModel?> getUserById(String id) async {
  final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
  if (userSnapshot.exists) {
    return UserModel.fromJson(userSnapshot.data()!);
  } else {
    return null;
  }
}

Future<UserModel?> getFullUserById(String id) async {
  final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
  if (userSnapshot.exists) {
    var user = UserModel.fromJson(userSnapshot.data()!);
    user.createdRides = await getRidesByIds(user.createdRidesIds);
    user.joinedRides = await getRidesByIds(user.joinedRidesIds);
    user.completedRides = await getRidesByIds(user.completedRidesIds);
    return user;
  } else {
    return null;
  }
}

// returns full user with all rides, where all rides have author
Future<UserModel?> getFullUserWithAuthorById(String id) async {
  final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
  if (userSnapshot.exists) {
    var user = UserModel.fromJson(userSnapshot.data()!);
    user.createdRides = await getRidesWithAuthorByIds(user.createdRidesIds);
    user.joinedRides = await getRidesWithAuthorByIds(user.joinedRidesIds);
    user.completedRides = await getRidesWithAuthorByIds(user.completedRidesIds);
    return user;
  } else {
    return null;
  }
}

// returns full user with rides (rides only have basic attributes - no author or participants)
Future<UserModel> getFullUser(UserModel user) async {
  user.createdRides = await getRidesByIds(user.createdRidesIds);
  user.joinedRides = await getRidesByIds(user.joinedRidesIds);
  user.completedRides = await getRidesByIds(user.completedRidesIds);
  return user;
}

Future<List<UserModel>> getUsersById(List<String> ids) async {
  final userSnapshots = await FirebaseFirestore.instance.collection('users').get();
  final filteredDocs = userSnapshots.docs.where((doc) => ids.contains(doc.id));
  return filteredDocs.map((doc) => UserModel.fromJson(doc.data())).toList();
}


Future<void> userUpdateAboutMe(UserStateController userController, String aboutMe) async {
  final user = userController.user;
  UserModel newUser = UserModel(
      lastName: user.lastName,
      firstName: user.firstName,
      email: user.email,
      avatarURL: user.avatarURL,
      aboutMe: aboutMe,
      completedRidesIds: user.completedRidesIds,
      createdRidesIds: user.createdRidesIds,
      joinedRidesIds: user.joinedRidesIds
  );
  userController.updateUser(newUser);
  await updateUser(user.getId(), newUser);
}

// DB shouldn't be handled inside state controller IMO,
Future<void> updateUser(String userId, UserModel updatedUser) async {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update(updatedUser.toJson())
      .then((_) => print('Updated user - ${updatedUser.email}'))
      .catchError((error) => print('Update failed - ${updatedUser.email}: $error'));
}

Future<void> updateRide(String rideId, RideModel updatedRide) async {
  return FirebaseFirestore.instance
      .collection('rides')
      .doc(rideId)
      .update(updatedRide.toJson())
      .then((_) => print('Updated ride - ${updatedRide.title} by ${updatedRide.authorId}'))
      .catchError((error) => print('Update failed - ${updatedRide.title} by ${updatedRide.authorId}: $error'));
}


