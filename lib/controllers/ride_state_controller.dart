import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/ride_model.dart';
import '../models/user_model.dart';

class RideStateController extends ChangeNotifier {
  // TODO: remove late and add ctor
  late RideModel ride;
  late UserModel author;  // get from DB based on ride.authorId
  late List<UserModel> participants; // get from DB based on ride.participantsIds

  // ride.participants.add(currentUser.id);
}