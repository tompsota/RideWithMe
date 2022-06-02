import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<T>> snapshotsToDtos<T>(Stream<QuerySnapshot<Map<String, dynamic>>> snapshots, T Function(Map<String, dynamic>) mapper) {
  return snapshots
      .map((snapshot) => snapshot.docs
      .map((doc) => mapper(doc.data())).toList())
      .asBroadcastStream(); // TODO: Observable / AsReusableStream from Rx ?
}