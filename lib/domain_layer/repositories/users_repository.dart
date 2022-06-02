// handles transformation of data from UsersApi and UserApi,
// to e.g. provide a stream of Users with authors and participants

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_with_me/data_layer/apis/users_api.dart';
import 'package:tuple/tuple.dart';

import '../../data_layer/apis/users_api.dart';
import '../models/user_model.dart';
import '../filters.dart';

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
  Stream<List<UserModel>> getUsers([bool Function(UserModel)? filter]) {
    return _usersApi
        .getUsers()
        .map((users) => users
          .map((user) => UserModel.fromDto(user))
          .where(filter ?? (_) => true)
          .toList())
        .asBroadcastStream();
  }

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
  }

  // if user is not signed in or he is signed in as anonymous user (email is null)
  bool _isUserSignedIn() {
    final authUser = FirebaseAuth.instance.currentUser;
    return authUser != null && (authUser.email?.isNotEmpty ?? false);
  }

  Tuple2<String, String> _getUserNames() {
    final authUser = FirebaseAuth.instance.currentUser;
    
    if (authUser == null) {
      return Tuple2("Unknown", "Unknown");
    }
    
    var userFirstName = authUser.displayName ?? "";
    var userLastName = "";
    if (authUser.displayName?.contains(' ') ?? false) {
      var names = authUser.displayName?.split(' ');
      if (names != null) {
        userFirstName = names[0].trim();
        userLastName = names.sublist(1).join(' ').trim();
      }
    }
    return Tuple2(userFirstName, userLastName);
  }

  Future<UserModel?> ensureUserExists() async {

    final authUser = FirebaseAuth.instance.currentUser;
    final email = authUser?.email;

    if (!_isUserSignedIn()) {
      return null;
    }

    final user = await getUserByEmail(authUser!.email!);

    if (user != null) {
      return user;
    } else {
      // create new user
      var userNames = _getUserNames();
      var userFirstName = userNames.item1;
      var userLastName = userNames.item2;

      final newUser = UserModel.id(
          email: email!,
          firstName: userFirstName,
          lastName: userLastName,
          aboutMe: "No info.",
          facebookAccount: '',
          slackAccount: '',
          instagramAccount: '',
          stravaAccount: '',
          googleAccount: '',
          avatarUrl: authUser.photoURL ?? "https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg");
      await createUser(newUser);
    }

    return getUserByEmail(email);
  }

  Future<void> updateUser(UserModel user) async {
      await _usersApi.updateUser(user.toDto());
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _usersApi.updateUserProfile(user.toDto());
  }

  Stream<UserModel> getUserStreamById(String id) {
    return _usersApi
        .getUserStreamById(id)
        .map(UserModel.fromDto)
        .asBroadcastStream();
  }

}
