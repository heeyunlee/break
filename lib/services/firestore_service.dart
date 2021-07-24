import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Making a private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  // Create new Data
  Future<void> setData<T>({
    required String path,
    required T data,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    await reference.set(data);
  }

  // Update Data (Used for creating new element in an array)
  Future<void> updateData<T>({
    required String path,
    required Map<String, dynamic> data,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );
    await reference.update(data);
  }

  // Delete data from Cloud Firestore
  Future<void> deleteData({
    required String path,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  // Document Future
  Future<T?> getDocument<T>({
    required String path,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );
    final snapshot = await reference.get();
    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

  // Document Stream
  Stream<T?> documentStream<T>({
    required String path,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path).withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();

    return snapshots.map((event) => event.data());
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required String order,
    required bool descending,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
    int? limit,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .orderBy(order, descending: descending)
        .limit(limit ?? 50)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<T>> collectionStreamWithWhereIsNull<T>({
    required String path,
    required String where,
    required String order,
    required bool descending,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
    int? limit,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(where, isNull: false)
        .orderBy(order, descending: descending)
        .limit(limit ?? 50)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<T>> collectionStreamOfThisWeek<T>({
    required String path,
    String? uid,
    String? uidVariableName,
    required String dateVariableName,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final lastWeek = DateTime.now().subtract(Duration(days: 7));

    final reference = (uid != null && uidVariableName != null)
        ? FirebaseFirestore.instance
            .collection(path)
            .where(uidVariableName, isEqualTo: uid)
            .where(dateVariableName, isGreaterThanOrEqualTo: lastWeek)
            .orderBy(dateVariableName, descending: false)
            .withConverter<T>(
              fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
              toFirestore: (model, _) => toBuilder(model),
            )
        : FirebaseFirestore.instance
            .collection(path)
            .where(dateVariableName, isGreaterThanOrEqualTo: lastWeek)
            .orderBy(dateVariableName, descending: false)
            .withConverter<T>(
              fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
              toFirestore: (model, _) => toBuilder(model),
            );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<T>> collectionStreamOfThisWeek2<T>({
    required String path,
    required String uid,
    required String uidVariableName,
    required String dateVariableName,
    required String whereVariableName,
    required String isEqualToVariable,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final lastWeek = DateTime.now().subtract(Duration(days: 7));

    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(dateVariableName, isGreaterThanOrEqualTo: lastWeek)
        .where(uidVariableName, isEqualTo: uid)
        .where(whereVariableName, isEqualTo: isEqualToVariable)
        .orderBy(dateVariableName, descending: false)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<T>> collectionStreamOfToday<T>({
    required String path,
    required String uidVariableName,
    required String uid,
    required String dateVariableName,
    required String orderVariableName,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(uidVariableName, isEqualTo: uid)
        .where(dateVariableName, isEqualTo: today)
        .orderBy(orderVariableName, descending: false)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<T>> collectionStreamOfSelectedDay<T>({
    required String path,
    required String uidVariableName,
    required String uid,
    required String dateVariableName,
    DateTime? dateIsEqualTo,
    required String orderVariableName,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final day = dateIsEqualTo ?? DateTime.now();

    final dayInUtc = DateTime.utc(day.year, day.month, day.day);

    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(uidVariableName, isEqualTo: uid)
        .where(dateVariableName, isEqualTo: dayInUtc)
        .orderBy(orderVariableName, descending: false)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  // isEqualTo And OrderBy Stream
  Stream<List<T>> isEqualToOrderByCollectionStream<T>({
    required String path,
    required String whereVariableName,
    required dynamic isEqualToValue,
    required String orderByVariable,
    required bool isDescending,
    int? limit,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(whereVariableName, isEqualTo: isEqualToValue)
        .orderBy(orderByVariable, descending: isDescending)
        .limit(limit ?? 50)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  // Two Is Equal To Collection Stream
  Stream<List<T>> twoIsEqualToCollectionStream<T>({
    required String path,
    required String whereVariableName1,
    required dynamic isEqualToValue1,
    required String whereVariableName2,
    required dynamic isEqualToValue2,
    required String orderByVariable,
    required bool isDescending,
    int? limit,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(whereVariableName1, isEqualTo: isEqualToValue1)
        .where(whereVariableName2, isEqualTo: isEqualToValue2)
        .orderBy(orderByVariable, descending: isDescending)
        .limit(limit ?? 50)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  // Is Equal To And Array Contains Collection Stream
  Stream<List<T>> isEqualToArrayContainsCollectionStream<T>({
    required String path,
    required String whereVariableName,
    required dynamic isEqualToValue,
    required String arrayContainsVariableName,
    required dynamic arrayContainsValue,
    required String orderByVariable,
    required bool isDescending,
    int? limit,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(whereVariableName, isEqualTo: isEqualToValue)
        .where(arrayContainsVariableName, arrayContains: arrayContainsValue)
        .orderBy(orderByVariable, descending: isDescending)
        .limit(limit ?? 50)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    final snapshots = reference.snapshots();
    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  ///////// `BATCH` ////////////

  // Write more than one documents at once
  Future<void> batchData({
    required List<String> path,
    required List<Map<String, dynamic>> data,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var i = 0; i < path.length; i++) {
      final doc = FirebaseFirestore.instance.doc(path[i]);
      batch.set(doc, data[i]);
    }

    await batch.commit();
  }

  // Write more than one documents at once
  Future<void> batchDelete({
    required List<String> path,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var i = 0; i < path.length; i++) {
      final doc = FirebaseFirestore.instance.doc(path[i]);
      batch.delete(doc);
    }

    await batch.commit();
  }

  // Update one documents at once
  Future<void> batchUpdateData({
    required List<String> path,
    required List<Map<String, dynamic>> data,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var i = 0; i < path.length; i++) {
      final reference = FirebaseFirestore.instance.doc(path[i]);
      batch.update(reference, data[i]);
    }

    await batch.commit();
  }

  //////// `Query` ////////////

  Query<T> paginatedCollectionQuery<T>({
    required String path,
    required String orderBy,
    required bool descending,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final query = FirebaseFirestore.instance
        .collection(path)
        .orderBy(orderBy, descending: descending)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    return query;
  }

  Query<T> whereAndOrderByQuery<T>({
    required String path,
    required String where,
    required dynamic isEqualTo,
    required String orderBy,
    required bool descending,
    required Function(Map<String, dynamic>? data, String id) fromBuilder,
    required Function(T model) toBuilder,
  }) {
    final query = FirebaseFirestore.instance
        .collection(path)
        .where(where, isEqualTo: isEqualTo)
        .orderBy(orderBy, descending: descending)
        .withConverter<T>(
          fromFirestore: (json, _) => fromBuilder(json.data(), json.id),
          toFirestore: (model, _) => toBuilder(model),
        );

    return query;
  }
}
