import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/domain_layer/db_repository.dart';
import 'package:ride_with_me/domain_layer/users_repository.dart';
import 'package:ride_with_me/utils/db/user.dart';

import '../models/user_model.dart';

class UserStateController extends ChangeNotifier {

  // we retrieve UserModel from DB
  late UserModel user;

  UserStateController._create();

  /// Public factory
  static Future<UserStateController> create(UsersRepository usersRepository) async {
    final authUser = FirebaseAuth.instance.currentUser;
    final email = authUser?.email;
    var controller = UserStateController._create();
    // if user is not signed in or he is signed in as anonymous user (email is null)
    if (authUser == null || (authUser.email?.isEmpty ?? true)) {
      return controller;
    }

    // TODO: add try catch?
    final users = FirebaseFirestore.instance.collection('users');
    // TODO: use UsersRepository method

    final user = await usersRepository.getUserByEmail(authUser.email ?? "");

    if (user != null) {
      // we load the full user, so that when we enter ProfilePage, we already have precise InitialData (and the fetch will only update some values, if any)
      controller.user = user;
    } else {

      var userFirstName = authUser.displayName ?? "";
      var userLastName = "";
      if (authUser.displayName?.contains(' ') ?? false) {
        var names = authUser.displayName?.split(' ');
        if (names != null) {
          userFirstName = names[0].trim();
          userLastName = names.sublist(1).join(' ').trim();
        }
      }

      final newUser = UserModel.id(
          email: email ?? "",
          firstName: userFirstName,
          lastName: userLastName,
          aboutMe: "No info.",
          avatarUrl: authUser.photoURL ?? "https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg"
      );
      await usersRepository.createUser(newUser);
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