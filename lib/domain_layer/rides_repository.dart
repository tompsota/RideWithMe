// handles transformation of data from RidesApi and UserApi,
// to e.g. provide a stream of Rides with authors and participants

import 'package:flutter/material.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';

import '../data_layer/apis/users_api.dart';
import '../models/ride_model.dart';

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
  // TODO: rename 'filter' to something else
  Stream<List<RideModel>> getRides(bool Function(RideModel) filter) => _ridesApi
      .getRides()
      .map((rides) {
        return rides
            .map((ride) => RideModel.fromDto(ride))
            .where((rideModel) => filter(rideModel))
            .toList();
      })
      .asBroadcastStream();

  /// Provides a [Stream] of all rides with author and participants.
  // Stream<List<RideModel>> getFullRides(Function filter) {
  /// If filter is null, we keep all rides.
  Stream<List<RideModel>> getFullRides([bool Function(RideModel)? filter]) {
    // var users = _usersApi.getUsers();
    return _ridesApi
        .getRides()
        .map((rides) {
          return rides
              .map((ride) {
                var rideModel = RideModel.fromDto(ride);
                // add author and participants ?
                // rideModel.participants = ...;
                // rideModel.author = ...;
                return rideModel;
              })
              .where(filter ?? (_) => true)
              .toList();
        })
        .asBroadcastStream();
  }

  /// Saves a [ride].
  ///
  /// If a [ride] with the same id already exists, it will be replaced.
  Future<void> createRide(RideModel ride) async {
    await _ridesApi.createRide(ride.toDto());

    // TODO: update user's created rides
    // await _usersApi.updateUser(ride.author)

    // TODO: update participants
    // ride.participants.forEach((participant) async {
    //   await _usersApi.updateUser(participant);
    // });

  }


}
