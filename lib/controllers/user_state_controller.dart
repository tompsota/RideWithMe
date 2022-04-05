import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserStateController extends ChangeNotifier {
  // TODO: is it necessary to keep reference to User (FirebaseAuth.User) ??
  User? user;
  UserModel? customUser;

  UserStateController({required this.user});

  void init() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Query query = users.where("id", isEqualTo: user!.uid);
    QuerySnapshot querySnapshot = await query.get();
    final singleQuerySnapshot = querySnapshot.docs.single;
    if (singleQuerySnapshot == null) {
      // create new UserModel
    } else {
      this.customUser = UserModel.fromJson(querySnapshot.docs.single.data()! as Map<String, dynamic>);
    }
    // final String userJson = (await FirebaseFirestore.instance.collection('users').where("id", isEqualTo: user!.uid)) as String;

  }

// creates CustomUser in DB if he doesn't exist yet (based on user.uid)
// CustomUserModel.fromDB({required this.user}) {}

// TODO: make changes in DB as well (should be easy, since we have user.uid)
// TODO: do we only allow users to specify profile pic URL? (or also upload
//       image and we save it/host it somewhere?)
// void updateAboutMe(String text) {
//   aboutMe = text;
//   notifyListeners();
// }
}