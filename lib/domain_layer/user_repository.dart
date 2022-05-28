// handles transformation of data from UsersApi and UserApi,
// to e.g. provide a stream of Users with authors and participants

import 'package:ride_with_me/data_layer/apis/users_api.dart';

import '../data_layer/apis/users_api.dart';
import '../models/user_model.dart';

/// {@template users_repository}
/// A repository that handles user related requests.
/// {@endtemplate}
class UsersRepository {
  /// {@macro users_repository}
  const UsersRepository({
    required UsersApi usersApi,
  }) :
        _usersApi = usersApi;

  final UsersApi _usersApi;

  /// Provides a [Stream] of all users.
  // TODO: rename 'filter' to something else
  Stream<List<UserModel>> getUsers(bool Function(UserModel) filter) => _usersApi
      .getUsers()
      .map((users) {
    return users
        .map((user) => UserModel.fromDto(user))
        .where((userModel) => filter(userModel))
        .toList();
  })
      .asBroadcastStream();

  // TODO: change to getUserById or something similar ??
  // (we don't have access to Id tho, since we use randomly generated Uuid, and not firebaseAuth.user.uid)
  Future<UserModel?> getUserByEmail(String email) async {
    final user = await _usersApi.getUserByEmail(email);
    return user == null ? null : UserModel.fromDto(user);
  }

  /// Provides a [Stream] of all users with author and participants.
  // Stream<List<UserModel>> getFullUsers(Function filter) {
  Stream<List<UserModel>> getFullUsers() {
    // var users = _usersApi.getUsers();
    return _usersApi
        .getUsers()
        .map((users) {
      return users.map((user) {
        var userModel = UserModel.fromDto(user);
        // add author and participants
        return userModel;
      }).toList();
    })
        .asBroadcastStream();
  }

  /// Saves a [user].
  ///
  /// If a [user] with the same id already exists, it will be replaced.
  Future<void> createUser(UserModel user) async {
    await _usersApi.createUser(user.toDto());

    // TODO: update user's created users
    // await _usersApi.updateUser(user.author)

    // TODO: update participants
    // user.participants.forEach((participant) async {
    //   await _usersApi.updateUser(participant);
    // });

  }


}
