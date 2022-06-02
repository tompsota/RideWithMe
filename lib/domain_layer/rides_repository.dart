// handles transformation of data from RidesApi and UserApi,
// to e.g. provide a stream of Rides with authors and participants

import 'package:flutter/material.dart';
import 'package:ride_with_me/data_layer/apis/rides_api.dart';
import 'package:ride_with_me/domain_layer/utils.dart';

import '../data_layer/apis/users_api.dart';
import '../models/filter_model.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';
import 'filters.dart';

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
    return getFullRides(transformStream(_ridesApi.getRidesFromCollection(ridesIds), RideModel.fromDto));
  }

  Stream<List<RideModel>> getFilteredRides(FilterModel filter) {
    return getFullRides(transformStream(_ridesApi.getRides(), RideModel.fromDto, Filters.passesRidesFilter(filter)));
  }
  
  /// Provides a [Stream] of all rides with author included.
  Stream<List<RideModel>> getFullRides(Stream<List<RideModel>> ridesStream) async* {
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
              .whereType()
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

    // await _ridesApi.joinRide(ride.id, ride.authorId);
  }

}
