import '../models/ride_model.dart';
import '../models/user_model.dart';


typedef UserModelFilter = bool Function(UserModel user);
typedef RideModelFilter = bool Function(RideModel ride);

class Filters {

  static UserModelFilter isParticipant(RideModel ride) {
    return (UserModel user) => ride.participantsIds.contains(user.id);
  }

  static RideModelFilter isRideFromCollection(List<String> ridesIds) {
    return (RideModel ride) => ridesIds.contains(ride.id);
  }
}