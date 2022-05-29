import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:ride_with_me/data_layer/apis/users_api.dart';

import '../dtos/user.dart';


/// {@template local_storage_users_api}
/// A Flutter implementation of the [UsersApi] that uses local storage.
/// {@endtemplate}
class FirestoreUsersApi implements UsersApi {
  FirestoreUsersApi();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  @override
  Stream<List<User>> getUsers() => _firestore
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => User.fromJson(doc.data())).toList())
      .asBroadcastStream(); // TODO: AsReusableStream from Rx ?

  // User getUser(String id) => firestore
  //     .collection('users')
  //     .where("id", isEqualTo: id)
  //     .snapshots().



  @override
  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }


  @override
  Future<void> createUser(User user) async {
    await _firestore.collection('users').add(user.toJson());

    // final users = [..._userStreamController.value];
    // final userIndex = users.indexWhere((t) => t.id == user.id);
    // if (userIndex >= 0) {
    //   users[userIndex] = user;
    // } else {
    //   users.add(user);
    // }

    // _userStreamController.add(users);
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.length != 1) {
      return null;
    }

    return User.fromJson(snapshot.docs.single.data());
  }

  // can fetch doc directly ?
  @override
  Future<User?> getUserById(String id) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(id)
        // .where('id', isEqualTo: id)
        .get();

    if (snapshot.data() == null) {
      return null;
    }
    return User.fromJson(snapshot.data()!);
  }


}