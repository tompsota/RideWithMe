import 'package:cloud_firestore/cloud_firestore.dart';

import 'dtos/user.dart';

/// Function that can be used by any API implementation to transform a stream
/// of query snapshots to a stream of list of a DTO of type [T].
/// Used when working with list of DTOs / models.
/// Mapper is generally an implementation of DTO's `fromJson` method.
Stream<List<T>> querySnapshotsToDtos<T>(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots, T Function(Map<String, dynamic>) mapper) {
  return snapshots
      .map((snapshot) => snapshot.docs
      .map((doc) => mapper(doc.data())).toList())
      .asBroadcastStream();
}

/// Function that can be used by any API implementation to transform a stream
/// of document snapshots to a stream of a DTO of type [T].
/// Used when working with a single DTOs / models.
/// Mapper is generally an implementation of DTO's `fromJson` method.
Stream<T> documentSnapshotsToDtos<T>(Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots, T Function(Map<String, dynamic>) mapper) {
  return snapshots
      .map((snapshot) => snapshot.data())
      .where((data) => data != null)
      .map((data) => mapper(data!))
      .asBroadcastStream();
}


/// Retrieves only a subset of attributes of User class, that generally
/// can be edited by a user in ProfilePage.
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
