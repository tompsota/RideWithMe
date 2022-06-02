import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/data_layer/utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:ride_with_me/data_layer/apis/users_api.dart';

import '../dtos/user.dart';


/// {@template local_storage_users_api}
/// A Flutter implementation of the [UsersApi] that uses local storage.
/// {@endtemplate}
class FirestoreUsersApi implements UsersApi {
  FirestoreUsersApi();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getUsersCollection() => _firestore.collection('users');
  Stream<List<User>> _snapshotsToStream(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots) => snapshotsToDtos(snapshots, User.fromJson);

  @override
  Stream<List<User>> getUsers() => _snapshotsToStream(_getUsersCollection().snapshots());

  @override
  Future<void> updateUser(User user) async {
    await _getUsersCollection().doc(user.id).update(user.toJson());
  }


  // TODO: make a 'getUserProfile' method, which returns a Map<String, object>
  // or as a util, since DTOs should be 'dumb' ?
  // don't update any IDs
  Future<void> updateUserProfile(User user) async {
    await _getUsersCollection().doc(user.id).update({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'aboutMe': user.aboutMe,
      'facebookAccount': user.facebookAccount,
      'googleAccount': user.googleAccount,
      'instagramAccount': user.instagramAccount,
      'slackAccount': user.slackAccount,
      'stravaAccount': user.stravaAccount
    });
  }

  // either create doc with id = Uuid().v4() that we generated ourselves before,
  // or use Firebase's generated ID and update the model
  @override
  Future<String> createUser(User user) async {

    // sets id to Uuid().v4() that we generated ourselves
    // await _getUsersCollection().doc(user.id).set(user.toJson());
    
    // ID is created by Firebase, then we update user's ID to this ID
    final newUser = await _getUsersCollection().add(user.toJson());
    await newUser.update({'id': newUser.id});
    return newUser.id;
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final snapshot = await _getUsersCollection()
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.length != 1) {
      return null;
    }

    return User.fromJson(snapshot.docs.single.data());
  }

  @override
  Future<User?> getUserById(String id) async {
    final snapshot = await _getUsersCollection()
        .doc(id)
        .get();

    if (snapshot.data() == null) {
      return null;
    }
    return User.fromJson(snapshot.data()!);
  }

  @override
  Future<void> createRide(String rideId, String userId) async {
    await _getUsersCollection()
        .doc(userId)
        .update({"createdRidesIds": FieldValue.arrayUnion([rideId]),});
  }

  @override
  Future<void> leaveRide(String rideId, String userId) async {
    await _getUsersCollection()
        .doc(userId)
        .update({"joinedRidesIds": FieldValue.arrayRemove([rideId]),});
  }

  @override
  Future<void> joinRide(String rideId, String userId) async {
    await _getUsersCollection()
        .doc(userId)
        .update({"joinedRidesIds": FieldValue.arrayUnion([rideId]),});
  }

  @override
  Future<void> completeRide(String rideId, String userId) async {
    await _getUsersCollection()
        .doc(userId)
        .update({"completedRidesIds": FieldValue.arrayUnion([rideId]),});
  }

  Stream<List<User>> getParticipants(List<String> participantsIds) {
    return _snapshotsToStream(_getUsersCollection()
        .where('id', whereIn: participantsIds)
        .snapshots());
  }

}