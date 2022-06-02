// handles transformation of data from RidesApi and UserApi,
// to e.g. provide a stream of Rides with authors and participants

import 'package:flutter/material.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';
import 'package:ride_with_me/domain_layer/utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../data_layer/apis/users_api.dart';
import '../models/filter_model.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';
import '../filters.dart';

/// {@template rides_repository}
/// A repository that handles ride related requests.
/// {@endtemplate}
class RidesRepository {
  /// {@macro rides_repository}
  const RidesRepository({
    required RidesApi ridesApi,
    required UsersApi usersApi,
  }) :
        _ridesApi = ridesApi,
        _usersApi = usersApi;

  final RidesApi _ridesApi;
  final UsersApi _usersApi;

  /// Provides a [Stream] of all rides.
  /// If filter is null, we keep all rides.
  Stream<List<RideModel>> getRides([bool Function(RideModel)? filter]) {
    return getFullRides(transformStream(_ridesApi.getRides(), RideModel.fromDto, filter));
  }

  Stream<List<RideModel>> getRidesFromCollection(List<String> ridesIds) {
    return getFullRides(transformStream(_ridesApi.getRides(), RideModel.fromDto, Filters.isRideFromCollection(ridesIds)));
  }

  Stream<List<RideModel>> getFilteredRides(FilterModel filter) {
    return getFullRides(transformStream(_ridesApi.getRides(), RideModel.fromDto, Filters.passesRidesFilter(filter)));
  }

  /// Provides a [Stream] of all rides with author included.
  Stream<List<RideModel>> getFullRides(Stream<List<RideModel>> ridesStream) {
    final usersStream = transformStream(_usersApi.getUsers(), UserModel.fromDto);

    return Rx.combineLatest2(ridesStream, usersStream, (List<RideModel> rides, List<UserModel> users) {
      return rides.map((ride) {
        final authors = users.where((user) => user.id == ride.authorId).toList();
        if (authors.length != 1) {
          return null;
        }
        ride.author = authors[0];
        return ride;
      }).whereType<RideModel>().toList();
    }).asBroadcastStream();
  }

  Future<void> joinRide(String rideId, String userId) async {
    await _ridesApi.addParticipant(rideId, userId);
    await _usersApi.joinRide(rideId, userId);
  }

  Future<void> leaveRide(String rideId, String userId) async {
    await _ridesApi.removeParticipant(rideId, userId);
    await _usersApi.leaveRide(rideId, userId);
  }

  Future<void> completeRide(String rideId, String userId) async {
    await _usersApi.completeRide(rideId, userId);
    await _usersApi.leaveRide(rideId, userId);
  }

  Future<void> markRideAsCompleted(RideModel ride) async {
    await _ridesApi.markRideAsCompleted(ride.id);
    ride.participantsIds.forEach((userId) async => await completeRide(ride.id, userId));
  }

  /// Creates a [ride].
  /// If a [ride] with the same id already exists, it will be replaced.
  Future<void> createRide(RideModel ride) async {

    // Assumptions: authorId is set, ride.participantsIds = [authorId]
    final newRideId = await _ridesApi.createRide(ride.toDto());
    await _ridesApi.addParticipant(newRideId, ride.authorId);
    await _usersApi.createRide(newRideId, ride.authorId);
    await _usersApi.joinRide(newRideId, ride.authorId);
  }

}
