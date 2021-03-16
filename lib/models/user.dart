import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  User({
    @required this.userId,
    @required this.userName,
    @required this.userEmail,
    @required this.signUpDate,
    @required this.signUpProvider,
    this.savedWorkouts,
    this.savedRoutines,
    this.totalWeights,
    this.totalNumberOfWorkouts,
    this.unitOfMass,
    this.lastLoginDate,
    this.workoutHistories,
  });

  final String userId;
  final String userName;
  final String userEmail;
  final Timestamp signUpDate;
  final String signUpProvider;
  final List<String> savedWorkouts;
  final List<String> savedRoutines;
  final double totalWeights;
  final int totalNumberOfWorkouts;
  final int unitOfMass;
  final Timestamp lastLoginDate;
  final List<WorkoutHistory> workoutHistories;

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userName = data['userName'];
    final String userEmail = data['userEmail'];
    final Timestamp signUpDate = data['signUpDate'];
    final String signUpProvider = data['signUpProvider'];
    final List<String> savedWorkouts = data['savedWorkouts'];
    final List<String> savedRoutines = data['savedRoutines'];
    final double totalWeights = data['totalWeights'];
    final int totalNumberOfWorkouts = data['totalNumberOfWorkouts'];
    final int unitOfMass = data['unitOfMass'];
    final Timestamp lastLoginDate = data['lastLoginDate'];
    final _workoutHistories = <WorkoutHistory>[];
    if (data['workoutHistories'] != null) {
      data['workoutHistories'].forEach((workoutHistory) {
        _workoutHistories.add(WorkoutHistory.fromMap(workoutHistory));
      });
    }

    return User(
      userId: documentId,
      userName: userName,
      userEmail: userEmail,
      signUpDate: signUpDate,
      signUpProvider: signUpProvider,
      savedWorkouts: savedWorkouts,
      savedRoutines: savedRoutines,
      totalWeights: totalWeights,
      totalNumberOfWorkouts: totalNumberOfWorkouts,
      unitOfMass: unitOfMass,
      lastLoginDate: lastLoginDate,
      workoutHistories: _workoutHistories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'signUpDate': signUpDate,
      'signUpProvider': signUpProvider,
      'savedWorkouts': savedWorkouts,
      'savedRoutines': savedRoutines,
      'totalWeights': totalWeights,
      'totalNumberOfWorkouts': totalNumberOfWorkouts,
      'unitOfMass': unitOfMass,
      'lastLoginDate': lastLoginDate,
      'workoutHistories': workoutHistories,
    };
  }
}

class WorkoutHistory {
  WorkoutHistory({this.date, this.totalWeights});

  final Timestamp date;
  final double totalWeights;

  factory WorkoutHistory.fromMap(Map<String, dynamic> data) {
    if (data != null) {
      return null;
    }

    final Timestamp date = data['date'];
    final double totalWeights = data['totalWeights'];

    return WorkoutHistory(
      date: date,
      totalWeights: totalWeights,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'totalWeights': totalWeights,
    };
  }
}
