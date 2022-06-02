import '../dtos/user.dart';


/// The interface for an API that provides access for accessing and
/// manipulating users.
abstract class UsersApi {

  const UsersApi();

  /// Provides a stream of all users.
  Stream<List<User>> getAllUsers();

  /// Returns user or null, if user with given email does not exist.
  Future<User?> getUserByEmail(String email);

  /// Returns a stream with user.
  /// Use: Supply to StreamBuilder to have a responsive ProfilePage.
  Stream<User> getUserStreamById(String id);

  /// Returns user or null, if user with given id does not exist.
  Future<User?> getUserById(String id);

  /// Creates a user and returns id that was created.
  Future<String> createUser(User user);

  /// Updates a user.
  Future<void> updateUser(User user);

  /// Updates user's profile info.
  /// Use: Only update attributes that can be edited in ProfilePage.
  Future<void> updateUserProfile(User user);

  /// Adds the id of a created ride to 'createdRidesIds'.
  Future<void> createRide(String rideId, String userId);

  /// Adds the id of a joined ride to 'joinedRidesIds'.
  Future<void> joinRide(String rideId, String userId);

  /// Removes the id of a specific ride from 'joinedRidesIds'.
  Future<void> leaveRide(String rideId, String userId);

  /// Adds the id of a completed ride to 'completedRidesIds'.
  Future<void> completeRide(String rideId, String userId);
}
