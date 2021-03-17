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
    this.dailyWorkoutHistories,
  });

  String userId;
  String userName;
  String userEmail;
  Timestamp signUpDate;
  String signUpProvider;
  List<String> savedWorkouts;
  List<String> savedRoutines;
  double totalWeights;
  int totalNumberOfWorkouts;
  int unitOfMass;
  Timestamp lastLoginDate;
  // TODO: Make this work like Routine Workout
  List<dynamic> dailyWorkoutHistories;

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
    final List<dynamic> dailyWorkoutHistories = data['dailyWorkoutHistories'];

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
      dailyWorkoutHistories: dailyWorkoutHistories,
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
      'dailyWorkoutHistories': dailyWorkoutHistories,
    };
  }
}

class DailyWorkoutHistory {
  DailyWorkoutHistory({this.date, this.totalWeights});

  final DateTime date;
  final double totalWeights;

  factory DailyWorkoutHistory.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final DateTime date = data['date'];
    final double totalWeights = data['totalWeights'];

    return DailyWorkoutHistory(
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
