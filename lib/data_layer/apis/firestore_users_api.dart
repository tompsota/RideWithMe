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
  Stream<List<User>> getUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => User.fromJson(doc.data())).toList())
        .asBroadcastStream(); // TODO: Observable / AsReusableStream from Rx ?
  }

  @override
  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }

  @override
  Future<void> createUser(User user) async {
    await _firestore.collection('users').add(user.toJson());
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

  @override
  Future<User?> getUserById(String id) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(id)
        .get();

    if (snapshot.data() == null) {
      return null;
    }
    return User.fromJson(snapshot.data()!);
  }

  @override
  Future<void> createRide(String rideId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({"createdRidesIds": FieldValue.arrayUnion([rideId]),});
  }

  @override
  Future<void> leaveRide(String rideId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({"joinedRidesIds": FieldValue.arrayRemove([rideId]),});
  }

  @override
  Future<void> joinRide(String rideId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({"joinedRidesIds": FieldValue.arrayUnion([rideId]),});
  }

  @override
  Future<void> completeRide(String rideId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({"completedRidesIds": FieldValue.arrayUnion([rideId]),});
  }

}