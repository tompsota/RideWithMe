import 'package:provider/provider.dart';
import 'package:ride_with_me/data_layer/apis/firestore_users_api.dart';
import 'package:ride_with_me/domain_layer/repositories/db_repository.dart';

import '../../data_layer/apis/firestore_rides_api.dart';


// TODO: should only be used while testing, since ChangeNotifierProviders are behaving in a weird way !!! TO BE DELETED LATER !!!

DbRepository getDbRepository() {
  return DbRepository(ridesApi: FirestoreRidesApi(), usersApi: FirestoreUsersApi());
}

ChangeNotifierProvider getDbRepositoryProvider() {
  return ChangeNotifierProvider(create: (_) => getDbRepository(),);
}