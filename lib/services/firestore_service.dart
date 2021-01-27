import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  // Making a private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  // Defines a single entry point for all writes to Firestore
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

  // Edit Data (Used for editing existing element in an array)
  Future<void> editData({
    @required String path,
    @required Map<String, dynamic> oldData,
    @required Map<String, dynamic> newData,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference
        .update(oldData)
        .then((value) => {reference.update(newData)});
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

  // Document Stream
  Stream<T> documentStream2<T>({
    @required String path,
    @required String documentId,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference =
        FirebaseFirestore.instance.collection(path).doc(documentId);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  // Getting all the streams available
  Stream<List<T>> collectionStreamWithoutOrder<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  // Getting all the streams available
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    @required String order,
  }) {
    final reference = FirebaseFirestore.instance.collection(path).orderBy(
          order,
          descending: false,
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
        .where('$searchCategory', isEqualTo: '$tag');
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  // Getting stream of 4 instances
  Stream<List<T>> initialCollectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path).limit(4);
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }
}
