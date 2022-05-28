import 'package:flutter/material.dart';
import 'package:ride_with_me/domain_layer/rides_repository.dart';
import 'package:ride_with_me/domain_layer/user_repository.dart';

import '../data_layer/apis/rides_api.dart';
import '../data_layer/apis/users_api.dart';

/// Wrapper class for all db repositories (users, rides).
class DbRepository extends ChangeNotifier {
  DbRepository({
    required RidesApi ridesApi,
    required UsersApi usersApi,
  }) :
        ridesRepository = RidesRepository(ridesApi: ridesApi, usersApi: usersApi),
        usersRepository = UsersRepository(usersApi: usersApi);

  final RidesRepository ridesRepository;
  final UsersRepository usersRepository;
}