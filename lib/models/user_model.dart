import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/ride_model.dart';
import 'package:uuid/uuid.dart';

import '../data_layer/dtos/user.dart';


class UserModel {

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String aboutMe;
  final List<String> createdRidesIds;
  final List<String> joinedRidesIds;
  final List<String> completedRidesIds;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.aboutMe = 'No info',
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const [],
  });

  UserModel.id({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.aboutMe = 'No info',
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const [],
  }) : id = Uuid().v4();

  factory UserModel.fromDto(User user) => UserModel(
    id: user.id,
    email: user.email,
    firstName: user.firstName,
    lastName: user.lastName,
    avatarUrl: user.avatarUrl,
    aboutMe: user.aboutMe,
    createdRidesIds: user.createdRidesIds,
    joinedRidesIds: user.joinedRidesIds,
    completedRidesIds: user.completedRidesIds
  );

  User toDto() => User(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    avatarUrl: avatarUrl,
    aboutMe: aboutMe,
    createdRidesIds: createdRidesIds,
    joinedRidesIds: joinedRidesIds,
    completedRidesIds: completedRidesIds
  );

  String getFullName() => firstName + " " + lastName;
}