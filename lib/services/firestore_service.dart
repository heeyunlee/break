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

  // Create new Data if NOT exist, and Update data if data already exists
  Future<void> getData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.get().then(
      (value) {
        if (value.exists) {
          return reference.update(data);
        } else {
          reference.set(data);
        }
      },
    );
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

  // Collection Stream with/without limit and with order
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

  // Collection Stream with/without limit and with order
  Stream<List<T>> publicCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
    @required bool descending,
    int limit,
  }) {
    final reference = (limit != null)
        ? FirebaseFirestore.instance
            .collection(path)
            .where('isPublic', isEqualTo: true)
            .limit(limit)
            .orderBy(
              order,
              descending: descending,
            )
        : FirebaseFirestore.instance
            .collection(path)
            .where('isPublic', isEqualTo: true)
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

  // Getting all the streams available
  Stream<List<T>> userCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String searchCategory,
    @required String searchString,
    @required String order,
    @required bool descending,
    int limit,
  }) {
    final reference = (limit != null)
        ? FirebaseFirestore.instance
            .collection(path)
            .limit(limit)
            .where(searchCategory, isEqualTo: searchString)
            .orderBy(
              order,
              descending: descending,
            )
        : FirebaseFirestore.instance
            .collection(path)
            .where(
              '$searchCategory',
              isEqualTo: '$searchString',
            )
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
  Stream<List<T>> publicSearchCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
    String searchCategory,
    String isEqualTo,
    String arrayContains,
    int limit,
  }) {
    final reference = (limit != null)
        ? (isEqualTo != null)
            ? FirebaseFirestore.instance
                .collection(path)
                .orderBy(order, descending: false)
                .where('isPublic', isEqualTo: true)
                .where('$searchCategory', isEqualTo: '$isEqualTo')
                .limit(limit)
            : FirebaseFirestore.instance
                .collection(path)
                .orderBy(
                  order,
                  descending: false,
                )
                .where('isPublic', isEqualTo: true)
                .where('$searchCategory', arrayContains: '$arrayContains')
                .limit(limit)
        : (isEqualTo != null)
            ? FirebaseFirestore.instance
                .collection(path)
                .orderBy(
                  order,
                  descending: false,
                )
                .where('isPublic', isEqualTo: true)
                .where('$searchCategory', isEqualTo: '$isEqualTo')
            : FirebaseFirestore.instance
                .collection(path)
                .orderBy(
                  order,
                  descending: false,
                )
                .where('isPublic', isEqualTo: true)
                .where('$searchCategory', arrayContains: '$arrayContains');
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  // Search Second Collection Stream
  Stream<List<T>> publicSearchCollectionStream2<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
    String searchCategory,
    String arrayContains,
    String searchCategory2,
    String arrayContains2,
    int limit,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .orderBy(order, descending: false)
        .where('isPublic', isEqualTo: true)
        .where('$searchCategory', arrayContains: '$arrayContains')
        .where('$searchCategory2', arrayContains: '$arrayContains2')
        .limit(limit);

    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  // Search Third Collection Stream
  Stream<List<T>> publicSearchCollectionStream3<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
    String searchCategory,
    String arrayContains,
    int limit,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .orderBy(order, descending: false)
        .where('isPublic', isEqualTo: true)
        .where('$searchCategory', arrayContains: '$arrayContains')
        .limit(limit);

    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }
}
