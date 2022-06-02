import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';

import '../dtos/ride.dart';
import '../utils.dart';



/// An implementation of the RidesApi that uses Firebase Firestore.
class FirestoreRidesApi implements RidesApi {

  FirestoreRidesApi();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getRidesCollection() {
    return _firestore.collection('rides');
  }

  Stream<List<Ride>> _snapshotsToDtos(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots) {
    return querySnapshotsToDtos(snapshots, Ride.fromJson);
  }

  @override
  Stream<List<Ride>> getAllRides() => _snapshotsToDtos(_getRidesCollection().snapshots());

  @override
  Stream<List<Ride>> getRidesFromCollection(List<String> ridesIds) {
    return _snapshotsToDtos(_getRidesCollection()
        // can't be empty
        .where('id', whereIn: ridesIds.isNotEmpty ? ridesIds : [""])
        .snapshots()
    );
  }

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