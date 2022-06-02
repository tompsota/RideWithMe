import '../dtos/ride.dart';

/// {@template rides_api}
/// The interface for an API that provides access to a list of rides.
/// {@endtemplate}
abstract class RidesApi {
  /// {@macro rides_api}
  const RidesApi();

  /// Provides a [Stream] of all rides.
  Stream<List<Ride>> getRides();
  Stream<List<Ride>> getRidesFromCollection(List<String> ridesIds);

  /// Saves a [ride].
  ///
  /// If a [ride] with the same id already exists, it will be replaced.
  Future<String> createRide(Ride ride);

  Future<void> addParticipant(String rideId, String userId);
  Future<void> removeParticipant(String rideId, String userId);

  /// Updates a [ride].
  ///
  /// If a [ride] with given id does not exist, it will be created.
  Future<void> updateRide(Ride ride);

  /// Deletes the ride with the given id.
  ///
  /// If no ride with the given id exists, a [RideNotFoundException] error is
  /// thrown.
  // Future<void> deleteRide(String id);

  Future<void> markRideAsCompleted(String rideId);

}

/// Error thrown when a [Ride] with a given id is not found.
class RideNotFoundException implements Exception {}