import '../dtos/user.dart';

/// {@template users_api}
/// The interface for an API that provides access to a list of users.
/// {@endtemplate}
abstract class UsersApi {
  /// {@macro users_api}
  const UsersApi();

  /// Provides a [Stream] of all users.
  Stream<List<User>> getUsers();

  /// Returns user or null, if user with given email does not exist.
  Future<User?> getUserByEmail(String email);

  /// Returns user or null, if user with given id does not exist.
  Future<User?> getUserById(String id);

  /// Saves a [user].
  ///
  /// If a [user] with the same id already exists, it will be replaced.
  Future<void> createUser(User user);

  /// Updates a [user].
  ///
  /// If a [user] with given id does not exist, it will be created.
  Future<void> updateUser(User user);

  Future<void> createRide(String rideId, String userId);
  Future<void> joinRide(String rideId, String userId);
  Future<void> leaveRide(String rideId, String userId);
  Future<void> completeRide(String rideId, String userId);

/// Deletes the user with the given id.
///
/// If no user with the given id exists, a [UserNotFoundException] error is
/// thrown.
// Future<void> deleteUser(String id);
}

/// Error thrown when a [User] with a given id is not found.
class UserNotFoundException implements Exception {}