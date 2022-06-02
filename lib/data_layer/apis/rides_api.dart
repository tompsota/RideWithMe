import '../dtos/ride.dart';


/// The interface for an API that provides access for accessing and
/// manipulating rides.
abstract class RidesApi {

  const RidesApi();

  /// Provides a stream of all rides.
  Stream<List<Ride>> getAllRides();

  /// Provides a stream of rides with specified id's
  /// Use: retrieve user's created, joined and completed rides
  Stream<List<Ride>> getRidesFromCollection(List<String> ridesIds);

  /// Creates a ride.
  Future<String> createRide(Ride ride);

  /// Adds user's id to a list of participants.
  Future<void> addParticipant(String rideId, String userId);

  /// Remove user's id from a list of participants.
  Future<void> removeParticipant(String rideId, String userId);

  /// Updates a ride.
  Future<void> updateRide(Ride ride);

  /// Sets 'isComplete' to true.
  Future<void> markRideAsCompleted(String rideId);
}
