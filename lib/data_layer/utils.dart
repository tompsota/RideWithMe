import 'package:cloud_firestore/cloud_firestore.dart';

import 'dtos/user.dart';

Stream<List<T>> snapshotsToDtos<T>(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots, T Function(Map<String, dynamic>) mapper) {
  return snapshots
      .map((snapshot) => snapshot.docs
      .map((doc) => mapper(doc.data())).toList())
      .asBroadcastStream(); // TODO: Observable / AsReusableStream from Rx ?
}

Map<String, dynamic> getUserInfo(User user) {
  return {
    'firstName': user.firstName,
    'lastName': user.lastName,
    'email': user.email,
    'avatarUrl': user.avatarUrl,
    'aboutMe': user.aboutMe,
    'facebookAccount': user.facebookAccount,
    'googleAccount': user.googleAccount,
    'instagramAccount': user.instagramAccount,
    'slackAccount': user.slackAccount,
    'stravaAccount': user.stravaAccount
  };
}