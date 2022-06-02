import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/streams.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';

import '../dtos/ride.dart';
import '../utils.dart';


/// {@template local_storage_rides_api}
/// A Flutter implementation of the [RidesApi] that uses local storage.
/// {@endtemplate}
class FirestoreRidesApi implements RidesApi {
  FirestoreRidesApi();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getRidesCollection() => _firestore.collection('rides');
  Stream<List<Ride>> _snapshotsToDtos(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots) => snapshotsToDtos(snapshots, Ride.fromJson);

  @override
  Stream<List<Ride>> getRides() => _snapshotsToDtos(_getRidesCollection().snapshots());
  // Stream<List<Ride>> getRides() {
  //   return _firestore.collection('rides')
  // }

  @override
  Stream<List<Ride>> getRidesFromCollection(List<String> ridesIds) {
    return _snapshotsToDtos(_getRidesCollection()
        // can't be empty
        .where('id', whereIn: ridesIds.isNotEmpty ? ridesIds : [""])
        .snapshots()
    );
  }

  // TODO: should have 'then' and 'catchError' / 'onError' ?
  @override
  Future<void> updateRide(Ride ride) async {
    await _getRidesCollection()
        .doc(ride.id)
        .update(ride.toJson())
        .then((value) => null)
        .catchError((error) => null);
  }


  @override
  Future<String> createRide(Ride ride) async {

    // sets id to Uuid().v4() that we generated ourselves
    // await _getRidesCollection().doc(ride.id).set(ride.toJson());

    // ID is created by Firebase, then we update ride's ID to this ID
    final newRide = await _getRidesCollection().add(ride.toJson());
    await newRide.update({'id': newRide.id});
    return newRide.id;
  }

  @override
  Future<void> removeParticipant(String rideId, String userId) async {
    await _firestore
        .collection('rides')
        .doc(rideId)
        .update({"participantsIds": FieldValue.arrayRemove([userId]),});
  }

  @override
  Future<void> addParticipant(String rideId, String userId) async {
    await _firestore
        .collection('rides')
        .doc(rideId)
        .update({"participantsIds": FieldValue.arrayUnion([userId]),});
  }

  @override
  Future<void> markRideAsCompleted(String rideId) async {
    await _firestore
        .collection('rides')
        .doc(rideId)
        .update({"isCompleted": true});
  }

}