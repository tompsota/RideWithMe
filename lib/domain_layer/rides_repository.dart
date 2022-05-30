// handles transformation of data from RidesApi and UserApi,
// to e.g. provide a stream of Rides with authors and participants

import 'package:flutter/material.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';

import '../data_layer/apis/users_api.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';

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
    // var users = _usersApi.getUsers();
    return _ridesApi
        .getRides()
        .map((rides) {
          return rides
              .map((ride) => RideModel.fromDto(ride))
              .where(filter ?? (_) => true)
              .toList();
        })
        .asBroadcastStream();
  }

  /// Provides a [Stream] of all rides with author and participants.
  Stream<List<RideModel>> getFullRides([bool Function(RideModel)? filter]) async* {
    var ridesStream = getRides(filter);
    List<RideModel> fullRides = [];

    await for (var rides in ridesStream) {
      for (var ride in rides) {
        var author = await _usersApi.getUserById(ride.authorId);
        if (author != null) {
          ride.author = UserModel.fromDto(author);
          fullRides.add(ride);
        }
      }
      yield fullRides;
    }
  }

  Stream<List<RideModel>> getFullRides_2() {
    return getRides()
        .asyncMap<List<RideModel>>((rides) => Future.wait(
          rides
              .map<Future<RideModel?>>((ride) async {
                var author = await _usersApi.getUserById(ride.authorId);
                if (author == null) {
                  return null;
                }
                ride.author = UserModel.fromDto(author);
                return ride;
              })
              // .whereType<Future<RideModel>>()
              .whereType()
              // .where((ride) => ride != null).toList()
        )
    );
  }

  Future<void> joinRide(String rideId, String userId) async {
    await _ridesApi.joinRide(rideId, userId);
    await _usersApi.joinRide(rideId, userId);
  }

  Future<void> leaveRide(String rideId, String userId) async {
    await _ridesApi.leaveRide(rideId, userId);
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
  ///
  /// If a [ride] with the same id already exists, it will be replaced.
  Future<void> createRide(RideModel ride) async {

    // Assumptions: authorId is set, ride.participantsIds = [authorId]
    await _ridesApi.createRide(ride.toDto());
    await _usersApi.createRide(ride.id, ride.authorId);

    // TODO: if ride.participantsIds is being set to [userId (=authorId)], we can omit the call to API
    // if participants already contains userId, nothing will happen (? - shouldn't be added twice),
    //   otherwise userId will be added to ride.participantsIds
    // await _ridesApi.joinRide(ride.id, ride.authorId);
  }

}
