import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/db/user.dart';

import '../models/user_model.dart';

class UserStateController extends ChangeNotifier {

  // we retrieve UserModel from DB
  late UserModel user;

  UserStateController._create();

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

      var userFirstName = authUser.displayName ?? "";
      var userLastName = "";
      if (authUser.displayName?.contains(' ') ?? false) {
        var names = authUser.displayName?.split(' ');
        if (names != null) {
          userFirstName = names[0].trim();
          userLastName = names.sublist(1).join(' ').trim();
        }
      }

      final newUser = UserModel(
          email: email ?? "",
          firstName: userFirstName,
          lastName: userLastName,
          aboutMe: "No info.",
          avatarURL: authUser.photoURL ?? "https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg"
      );
      await addUser(newUser);
      controller.user = newUser;
    }

    return controller;
  }

  // TODO: probably can be removed, since this only updates UserStateController.user, and doesn't actually update DB (that's done elsewhere)
  // void addCreatedRide(String rideId) async {
  //   var updatedCreatedRidesIds = user.createdRidesIds;
  //   updatedCreatedRidesIds.add(rideId);
  //   UserModel newUser = UserModel(
  //       lastName: user.lastName,
  //       firstName: user.firstName,
  //       email: user.email,
  //       aboutMe: user.aboutMe,
  //       avatarURL: user.avatarURL,
  //       createdRidesIds: updatedCreatedRidesIds,
  //       completedRidesIds: user.completedRidesIds,
  //       joinedRidesIds: user.joinedRidesIds,
  //   );
  //   user = newUser;
  //   notifyListeners();
  // }
  //
  // // adds rideId to a list of joined rides (after clicking on 'I will participate' button)
  // // Future<void> addJoinedRide(String rideId) async {
  // void addJoinedRide(String rideId) async {
  //   var updatedJoinedRidesIds = user.joinedRidesIds;
  //   updatedJoinedRidesIds.add(rideId);
  //   UserModel newUser = UserModel(
  //       lastName: user.lastName,
  //       firstName: user.firstName,
  //       email: user.email,
  //       aboutMe: user.aboutMe,
  //       avatarURL: user.avatarURL,
  //       createdRidesIds: user.createdRidesIds,
  //       completedRidesIds: user.completedRidesIds,
  //       joinedRidesIds: updatedJoinedRidesIds
  //   );
  //   user = newUser;
  //   notifyListeners();
  // }


  void updateUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }
}