import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../utils/db_utils.dart';

class UserStateController extends ChangeNotifier {

  // waiting to get UserModel from DB might be too slow sometimes
  late UserModel user;

  // TODO extra: could create variable 'stateChanged: bool', and then we wouldn't have to reload user every time we switch to ProfilePage
  //      however, we don't have information about CompletedRides, since it's created independently of that user's actions
  //      - it's created when ride's author marks the ride as completed

  // create default/empty user so that we don't have to deal with nullable
  // but then we have to use 'late' keyword
  UserStateController._create() {}

  /// Public factory
  static Future<UserStateController> create() async {
    final authUser = FirebaseAuth.instance.currentUser;
    final email = authUser?.email;
    var controller = UserStateController._create();
    // if user is not signed in or he is signed in as anonymous user (email is null)
    if (authUser == null || (authUser.email?.isEmpty ?? true)) {
      return controller;
    }

    // TODO: add try catch?
    final users = FirebaseFirestore.instance.collection('users');
    final userSnapshot = await users.doc(email).get();
    if (userSnapshot.exists) {
      // we load the full user, so that when we enter ProfilePage, we already have precise InitialData (and the fetch will only update some values, if any)
      final user = UserModel.fromJson(userSnapshot.data()!);
      controller.user = await getFullUser(user);
    } else {
      Future<void> addUser(UserModel user) {
        return users
            .doc(email)
            .set(user.toJson())
            .then((value) => print("User added - ${user.email}."))
            .catchError((error) => print("Failed to add user - ${user.email}: $error"));
      }

      final newUser = UserModel(email: email ?? "N/A", firstName: authUser.displayName ?? "N/A", lastName: "N/A", aboutMe: "No info.");
      // TODO: use photoURL (some default user pic if it's null)
      await addUser(newUser);
      controller.user = newUser;
    }

    return controller;
  }


  // adds rideId to a list of create rides - we are the author (after clicking on 'Create ride' button)
  // Future<void> addCreatedRide(String rideId) async {
  void addCreatedRide(String rideId) async {
    var updatedCreatedRidesIds = user.createdRidesIds;
    updatedCreatedRidesIds.add(rideId);
    UserModel newUser = UserModel(
        lastName: user.lastName,
        firstName: user.firstName,
        email: user.email,
        aboutMe: user.aboutMe,
        createdRidesIds: updatedCreatedRidesIds,
        completedRidesIds: user.completedRidesIds,
        joinedRidesIds: user.joinedRidesIds,
    );
    // await updateDB(newUser);
    user = newUser;
    notifyListeners();
  }

  // adds rideId to a list of joined rides (after clicking on 'I will participate' button)
  // Future<void> addJoinedRide(String rideId) async {
  void addJoinedRide(String rideId) async {
    var updatedJoinedRidesIds = user.joinedRidesIds;
    updatedJoinedRidesIds.add(rideId);
    UserModel newUser = UserModel(
        lastName: user.lastName,
        firstName: user.firstName,
        email: user.email,
        aboutMe: user.aboutMe,
        createdRidesIds: user.createdRidesIds,
        completedRidesIds: user.completedRidesIds,
        joinedRidesIds: updatedJoinedRidesIds
    );
    // await updateDB(newUser);
    user = newUser;
    notifyListeners();
  }

  // DB shouldn't be handled inside state controller IMO,
  // Future<void> updateDB(UserModel updatedUser) async {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.getId())
  //       .update(updatedUser.toJson())
  //       .then((_) => print('Updated user - ${updatedUser.email}'))
  //       .catchError((error) => print('Update failed: $error'));
  // }

  void updateUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }
}