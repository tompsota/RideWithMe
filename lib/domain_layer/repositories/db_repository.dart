import 'package:flutter/material.dart';
import 'package:ride_with_me/domain_layer/repositories/rides_repository.dart';
import 'package:ride_with_me/domain_layer/repositories/users_repository.dart';

import '../../data_layer/apis/rides_api.dart';
import '../../data_layer/apis/users_api.dart';


/// Wrapper class for all db repositories (users, rides), providing easy access.
class DbRepository extends ChangeNotifier {
  DbRepository({
    required RidesApi ridesApi,
    required UsersApi usersApi,
  }) :
        ridesRepository = RidesRepository(ridesApi: ridesApi, usersApi: usersApi),
        usersRepository = UsersRepository(ridesApi: ridesApi, usersApi: usersApi);

  final RidesRepository ridesRepository;
  final UsersRepository usersRepository;
}