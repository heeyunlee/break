import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  // Making a private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  // Create new Data
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  // Update Data (Used for creating new element in an array)
  Future<void> updateData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  // Write more than one documents at once
  Future<void> batchData({
    @required List<String> path,
    @required List<Map<String, dynamic>> data,
  }) async {
    print('batch data triggered');
    final batch = FirebaseFirestore.instance.batch();

    for (var i = 0; i < path.length; i++) {
      final reference = FirebaseFirestore.instance.doc(path[i]);
      batch.set(reference, data[i]);
    }

    await batch.commit();
  }

  // Delete data from Cloud Firestore
  Future<void> deleteData({
    @required String path,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  // Document Stream
  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  // // Getting all the streams available
  // Stream<List<T>> collectionStreamWithoutOrder<T>({
  //   @required String path,
  //   @required T Function(Map<String, dynamic> data, String documentId) builder,
  // }) {
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map(
  //     // converting snapshots of data to list of Data
  //     (snapshot) => snapshot.docs
  //         .map((snapshot) => builder(snapshot.data(), snapshot.id))
  //         .toList(),
  //   );
  // }

  // Getting stream of 4 instances
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
    @required bool descending,
    int limit,
  }) {
    final reference = (limit != null)
        ? FirebaseFirestore.instance.collection(path).limit(limit).orderBy(
              order,
              descending: descending,
            )
        : FirebaseFirestore.instance.collection(path).orderBy(
              order,
              descending: descending,
            );
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  // Getting all the streams available
  Stream<List<T>> userCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String searchString,
    @required String userId,
    @required String order,
    @required bool descending,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where('$searchString', isEqualTo: '$userId')
        .orderBy(
          order,
          descending: descending,
        );
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  // Search Collection Stream
  Stream<List<T>> searchCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
    String searchCategory,
    String tag,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .orderBy(
          order,
          descending: false,
        )
        .where('$searchCategory', arrayContains: '$tag');
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }
}
