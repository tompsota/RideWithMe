import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@immutable
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'firstName')  // TODO: uses camelCase ?
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;
  @JsonKey(name: 'aboutMe')
  final String aboutMe;

  const UserModel({required this.id, required this.firstName, required this.lastName, this.aboutMe = 'No info'});

  // RideModel.id(this.name) : id = const Uuid().v1();

  // we pass the id of FirebaseAuth.currentUser
  // UserModel({required this.id}) {
  //   final String userJson = await FirebaseFirestore.instance.collection('users').where(FieldPath.documentId, isEqualTo: id)
  //   users.get()
  //   this.aboutMe = "test";
  // }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}