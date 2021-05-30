import 'package:cloud_firestore/cloud_firestore.dart';

typedef BoolCallback = void Function(bool val);

class FirestoreService {
  // Making a private constructor
  FirestoreService._();
  static final instance = FirestoreService._();

  // Create new Data
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  // Update Data (Used for creating new element in an array)
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  // Write more than one documents at once
  Future<void> batchData({
    required List<String> path,
    required List<Map<String, dynamic>> data,
  }) async {
    print('batch data triggered');
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
    print('batch data triggered');
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
    print('batch data triggered');
    final batch = FirebaseFirestore.instance.batch();

    for (var i = 0; i < path.length; i++) {
      final reference = FirebaseFirestore.instance.doc(path[i]);
      batch.update(reference, data[i]);
    }

    await batch.commit();
  }

  // Delete data from Cloud Firestore
  Future<void> deleteData({
    required String path,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  // Document Future
  Future<T?> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshot = await reference.get();
    if (snapshot.exists) {
      return builder(snapshot.data()!, snapshot.id);
    }
    return null;
  }

  // Document Stream
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()!, snapshot.id));
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String order,
    required bool descending,
    int? limit,
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

  // Stream<List<T>> collectionStreamOfThisWeek<T>({
  //   required String path,
  //   required T Function(Map<String, dynamic> data, String documentId) builder,
  // }) {
  //   final lastWeek = DateTime.now().subtract(Duration(days: 7));

  //   final reference = FirebaseFirestore.instance
  //       .collection(path)
  //       .where('loggedTime', isGreaterThanOrEqualTo: lastWeek)
  //       .orderBy('loggedTime', descending: true);

  //   final snapshots = reference.snapshots();
  //   return snapshots.map(
  //     // converting snapshots of data to list of Data
  //     (snapshot) => snapshot.docs
  //         .map((snapshot) => builder(snapshot.data(), snapshot.id))
  //         .toList(),
  //   );
  // }

  Stream<List<T>> collectionStreamOfThisWeek<T>({
    required String path,
    String? uid,
    String? uidVariableName,
    required String dateVariableName,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final lastWeek = DateTime.now().subtract(Duration(days: 7));

    final reference = (uid != null && uidVariableName != null)
        ? FirebaseFirestore.instance
            .collection(path)
            .where(uidVariableName, isEqualTo: uid)
            .where(dateVariableName, isGreaterThanOrEqualTo: lastWeek)
            .orderBy(dateVariableName, descending: false)
        : FirebaseFirestore.instance
            .collection(path)
            .where(dateVariableName, isGreaterThanOrEqualTo: lastWeek)
            .orderBy(dateVariableName, descending: false);

    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  Stream<List<T>> collectionStreamOfToday<T>({
    required String path,
    required String uidVariableName,
    required String uid,
    required String dateVariableName,
    required String orderVariableName,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(uidVariableName, isEqualTo: uid)
        .where(dateVariableName, isEqualTo: today)
        .orderBy(orderVariableName, descending: false);

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
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String order,
    required bool descending,
    int? limit,
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
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String searchCategory,
    String? searchString,
    required String order,
    required bool descending,
    int? limit,
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
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String order,
    String? searchCategory,
    String? isEqualTo,
    String? arrayContains,
    int? limit,
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
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String order,
    String? searchCategory,
    String? arrayContains,
    String? searchCategory2,
    String? arrayContains2,
    int limit = 10,
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
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String order,
    String? searchCategory,
    String? arrayContains,
    int limit = 10,
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

  Stream<List<T>> workoutHistoriesForRoutineHistoryStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    required String routineHistoryId,
  }) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where('routineHistoryId', isEqualTo: routineHistoryId)
        .orderBy('index', descending: false);
    final snapshots = reference.snapshots();
    return snapshots.map(
      // converting snapshots of data to list of Data
      (snapshot) => snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .toList(),
    );
  }

  //////// `Query` ////////////

  Query paginatedCollectionQuery<T>({
    required String path,
    required String order,
    required bool descending,
  }) {
    final query = FirebaseFirestore.instance
        .collection(path)
        .orderBy(order, descending: descending);

    return query;
  }

  Query paginatedPublicCollectionQuery<T>({
    required String path,
    required String order,
    required bool descending,
  }) {
    final query = FirebaseFirestore.instance
        .collection(path)
        .orderBy(order, descending: descending)
        .where('isPublic', isEqualTo: true);

    return query;
  }

  Query paginatedUserCollectionQuery<T>({
    required String path,
    required String order,
    required bool descending,
    required String id,
    String? userId,
  }) {
    final query = FirebaseFirestore.instance
        .collection(path)
        .orderBy(order, descending: descending)
        .where(id, isEqualTo: userId);

    return query;
  }
}
