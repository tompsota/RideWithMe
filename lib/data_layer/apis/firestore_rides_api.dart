import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';

import '../dtos/ride.dart';


/// {@template local_storage_rides_api}
/// A Flutter implementation of the [RidesApi] that uses local storage.
/// {@endtemplate}
class FirestoreRidesApi implements RidesApi {
  FirestoreRidesApi();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final _rideStreamController = BehaviorSubject<List<Ride>>.seeded(const []);
  // final StreamController _streamController = StreamController<Ride>.broadcast();
  
  @override
  Stream<List<Ride>> getRides() => _firestore
      .collection('rides')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Ride.fromJson(doc.data())).toList())
      .asBroadcastStream(); // TODO: AsReusableStream from Rx ?

  // Ride getRide(String id) => firestore
  //     .collection('rides')
  //     .where("id", isEqualTo: id)
  //     .snapshots().


  // TODO: should have 'then' and 'catchError' / 'onError' ?
  @override
  Future<void> updateRide(Ride ride) async {
    await _firestore
        .collection('rides')
        .doc(ride.id)
        .update(ride.toJson())
        .then((value) => null)
        .catchError((error) => null);
  }


  @override
  Future<void> createRide(Ride ride) async {
    await _firestore
        .collection('rides')
        .add(ride.toJson())
        .then((value) => null)
        .catchError((error) => null);

    // final rides = [..._rideStreamController.value];
    // final rideIndex = rides.indexWhere((t) => t.id == ride.id);
    // if (rideIndex >= 0) {
    //   rides[rideIndex] = ride;
    // } else {
    //   rides.add(ride);
    // }

    // _rideStreamController.add(rides);
  }



}