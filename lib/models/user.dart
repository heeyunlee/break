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
    this.dailyNutritionHistories,
    this.dailyWeightsGoal,
    this.dailyProteinGoal,
  });

  String userId;
  String userName;
  String userEmail;
  Timestamp signUpDate;
  String signUpProvider;
  List<String> savedWorkouts;
  List<String> savedRoutines;
  num totalWeights;
  int totalNumberOfWorkouts;
  int unitOfMass;
  Timestamp lastLoginDate;
  List<DailyWorkoutHistory> dailyWorkoutHistories;
  List<DailyNutritionHistory> dailyNutritionHistories;
  num dailyWeightsGoal;
  num dailyProteinGoal;

  factory User.fromJson(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final userName = data['userName'];
    final userEmail = data['userEmail'];
    final signUpDate = data['signUpDate'];
    final signUpProvider = data['signUpProvider'];
    final savedWorkouts = data['savedWorkouts'];
    final savedRoutines = data['savedRoutines'];
    final totalWeights = data['totalWeights'];
    final totalNumberOfWorkouts = data['totalNumberOfWorkouts'];
    final unitOfMass = data['unitOfMass'];
    final lastLoginDate = data['lastLoginDate'];
    // ignore: omit_local_variable_types
    List<DailyWorkoutHistory> dailyWorkoutHistories = <DailyWorkoutHistory>[];
    // ignore: omit_local_variable_types
    List<DailyNutritionHistory> dailyNutritionHistories =
        <DailyNutritionHistory>[];
    final dailyWeightsGoal = data['dailyWeightsGoal'];
    final dailyProteinGoal = data['dailyWeightsGoal'];

    if (data['dailyWorkoutHistories'] != null) {
      data['dailyWorkoutHistories'].forEach((item) {
        dailyWorkoutHistories.add(DailyWorkoutHistory.fromMap(item));
      });
    }

    if (data['dailyNutritionHistories'] != null) {
      data['dailyNutritionHistories'].forEach((item) {
        dailyNutritionHistories.add(DailyNutritionHistory.fromMap(item));
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
      dailyWorkoutHistories: dailyWorkoutHistories,
      dailyNutritionHistories: dailyNutritionHistories,
      dailyWeightsGoal: dailyWeightsGoal,
      dailyProteinGoal: dailyProteinGoal,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['signUpDate'] = signUpDate;
    data['signUpProvider'] = signUpProvider;
    data['savedWorkouts'] = savedWorkouts;
    data['savedRoutines'] = savedRoutines;
    data['totalWeights'] = totalWeights;
    data['totalNumberOfWorkouts'] = totalNumberOfWorkouts;
    data['unitOfMass'] = unitOfMass;
    data['lastLoginDate'] = lastLoginDate;
    if (dailyWorkoutHistories != null) {
      data['dailyWorkoutHistories'] =
          dailyWorkoutHistories.map((e) => e.toMap()).toList();
    }
    if (dailyNutritionHistories != null) {
      data['dailyNutritionHistories'] =
          dailyNutritionHistories.map((e) => e.toMap()).toList();
    }
    data['dailyWeightsGoal'] = dailyWeightsGoal;
    data['dailyProteinGoal'] = dailyProteinGoal;

    return data;
  }
}

class DailyWorkoutHistory {
  DailyWorkoutHistory({this.date, this.totalWeights});

  final DateTime date;
  final num totalWeights;

  factory DailyWorkoutHistory.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final DateTime date = data['date'].toDate();
    final num totalWeights = data['totalWeights'].toDouble();

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

class DailyNutritionHistory {
  DailyNutritionHistory({this.date, this.totalProteins});

  final DateTime date;
  final double totalProteins;

  factory DailyNutritionHistory.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final DateTime date = data['date'].toDate();
    final double totalProteins = data['totalProteins'].toDouble();

    return DailyNutritionHistory(
      date: date,
      totalProteins: totalProteins,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'totalProteins': totalProteins,
    };
  }
}
