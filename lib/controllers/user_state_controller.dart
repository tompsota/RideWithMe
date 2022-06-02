import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../domain_layer/models/user_model.dart';

class UserStateController extends ChangeNotifier {
  // currently is used mainly to have access to user's id
  late UserModel user;
  UserStateController();

  // void updateUser(UserModel newUser) {
  //   user = newUser;
  //   notifyListeners();
  // }
}
