import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserStateController extends ChangeNotifier {
  // TODO: is it necessary to keep reference to User (FirebaseAuth.User) ??

  // either provide UserModel directly in ctor or pass only email/uid and call init()
  // waiting to get UserModel from DB might be too slow sometimes
  late UserModel user;
  String? documentId;
  // DocumentReference? userDocument;

  // create default/empty user so that we don't have to deal with nullable
  // but then we have to use 'late' keyword
  UserStateController._create() {
    // user = UserModel(); //email: '', firstName: '', lastName: '');
  }
  // UserStateController._create();

  /// Public factory
  Future<UserStateController> create() async {
    final authUser = FirebaseAuth.instance.currentUser;
    final email = authUser?.email;
    var controller = UserStateController._create();
    // if user is not signed in or he is signed in as anonymous user (email is null)
    if (authUser == null || (authUser.email?.isEmpty ?? true)) {
      return controller;
    }

    // could we use documentId to find the user faster?
    //
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Query query = users.where("email", isEqualTo: authUser.email!);
    QuerySnapshot querySnapshot = await query.get();
    final userDocument = querySnapshot.docs.single;

    if (userDocument.exists) {
      user = UserModel.fromJson(userDocument.data()! as Map<String, dynamic>);
      documentId = userDocument.id;
    } else {
      // create new UserModel
      Future<void> addUser() {
        return users
            .add(UserModel(firstName: authUser.displayName!, email: email!, lastName: '').toJson()
        )
            .then((value) => documentId = value.id)
            .catchError((error) => print("Failed to add user: $error"));
      }

      await addUser();
    }

    // TODO: should notifyListeners() ? probably not necessary
    return controller;
  }

  // UserStateController({required this.user, required this.email});

// creates CustomUser in DB if he doesn't exist yet (based on user.uid)
// CustomUserModel.fromDB({required this.user}) {}

// TODO: make changes in DB as well (should be easy, since we have user.uid)
// TODO: do we only allow users to specify profile pic URL? (or also upload image and we save it/host it somewhere?)
  Future<void> updateAboutMe(String aboutMeText) async {
    // gotta create new instance, since attributes are immutable (the whole class is immutable)
    UserModel newUser = UserModel(lastName: user.lastName, firstName: user.firstName, email: '', aboutMe: aboutMeText);
    // UPDATE DB
    await updateDB(newUser);
    notifyListeners();
  }

  Future<void> updateDB(UserModel updatedUser) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .update(updatedUser.toJson())
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }
}