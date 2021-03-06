import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_with_me/data_layer/apis/users_api.dart';
import 'package:ride_with_me/domain_layer/repositories/rides_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../data_layer/apis/rides_api.dart';
import '../../data_layer/apis/users_api.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';
import '../filters.dart';
import '../utils.dart';


/// A repository that handles user related requests.
class UsersRepository {

  UsersRepository({
    required UsersApi usersApi,
    required RidesApi ridesApi,
  }) :
        _usersApi = usersApi,
        _ridesApi = ridesApi,
        _ridesRepository = RidesRepository(usersApi: usersApi, ridesApi: ridesApi);

  final UsersApi _usersApi;
  final RidesApi _ridesApi;
  final RidesRepository _ridesRepository;

  /// Provides a stream of all users, filtered out using filter, if provided.
  Stream<List<UserModel>> getUsers([bool Function(UserModel)? filter]) {
    return _usersApi
        .getAllUsers()
        .map((users) => users
          .map((user) => UserModel.fromDto(user))
          .where(filter ?? (_) => true)
          .toList())
        .asBroadcastStream();
  }


  /// Returns UserModel with given email, if such user exists.
  Future<UserModel?> getUserByEmail(String email) async {
    final user = await _usersApi.getUserByEmail(email);
    return user == null ? null : UserModel.fromDto(user);
  }

  /// Creates a user and returns the id that was generated.
  Future<String> createUser(UserModel user) async {
    return await _usersApi.createUser(user.toDto());
  }

  bool _isUserSignedIn() {
    final authUser = FirebaseAuth.instance.currentUser;
    return authUser != null && (authUser.email?.isNotEmpty ?? false);
  }

  /// Returns first name and last name, parsed from information
  /// about FirebaseAuth user.
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

  /// Creates a new user in the database, if a user with given email does not
  /// exist yet (is signing in for the first time).
  /// Otherwise retrieve existing user from database.
  Future<UserModel?> ensureUserExists() async {

    final authUser = FirebaseAuth.instance.currentUser;
    final email = authUser?.email;

    if (!_isUserSignedIn()) {
      return null;
    }

    final user = await getUserByEmail(authUser!.email!);

    if (user != null) {
      return user;
    }

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

  /// Returns user stream with joined, created and completed rides.
  /// Use: Gets rid of the the need to obtain each ridesStream individually,
  ///      making ProfileExpansionPanel more responsive as well.
  Stream<UserModel> getFullUserStreamById(String id) {
    final ridesStream = _ridesRepository.getRides();
    final userStream = getUserStreamById(id);

    return Rx.combineLatest2(userStream, ridesStream, (UserModel user, List<RideModel> rides) {
      user.joinedRides = rides.where((ride) => user.joinedRidesIds.contains(ride.id)).toList();
      user.createdRides = rides.where((ride) => user.createdRidesIds.contains(ride.id)).toList();
      user.completedRides = rides.where((ride) => user.completedRidesIds.contains(ride.id)).toList();
      return user;
    }).asBroadcastStream();
  }

  Stream<List<UserModel>> getParticipants(RideModel ride) {
    return getUsers(Filters.isParticipant(ride));
  }

}
