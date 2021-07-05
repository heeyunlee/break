import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String userName;
  final String? userEmail; // Nullable
  final Timestamp signUpDate;
  final String signUpProvider;
  final List<dynamic>? savedWorkouts; // Nullable
  final List<dynamic>? savedRoutines; // Nullable
  final num totalWeights;
  final int totalNumberOfWorkouts;
  final int unitOfMass;
  final Timestamp lastLoginDate;
  final List<DailyWorkoutHistory>? dailyWorkoutHistories; // Nullable
  final List<DailyNutritionHistory>? dailyNutritionHistories; // Nullable
  final num? dailyWeightsGoal; // Nullable
  final num? dailyProteinGoal; // Nullable
  final String displayName;
  final int? backgroundImageIndex; // Nullable

  const User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.signUpDate,
    required this.signUpProvider,
    required this.savedWorkouts,
    required this.savedRoutines,
    required this.totalWeights,
    required this.totalNumberOfWorkouts,
    required this.unitOfMass,
    required this.lastLoginDate,
    this.dailyWorkoutHistories,
    this.dailyNutritionHistories,
    this.dailyWeightsGoal,
    this.dailyProteinGoal,
    required this.displayName,
    this.backgroundImageIndex,
  });

  factory User.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userName = data['userName'];
      final String? userEmail = data['userEmail'];
      final Timestamp signUpDate = data['signUpDate'];
      final String signUpProvider = data['signUpProvider'];
      final List<dynamic>? savedWorkouts = data['savedWorkouts'];
      final List<dynamic>? savedRoutines = data['savedRoutines'];
      final num totalWeights = data['totalWeights'];
      final int totalNumberOfWorkouts = data['totalNumberOfWorkouts'];
      final int unitOfMass = data['unitOfMass'];
      final Timestamp lastLoginDate = data['lastLoginDate'];
      List<DailyWorkoutHistory>? dailyWorkoutHistories =
          <DailyWorkoutHistory>[];
      List<DailyNutritionHistory>? dailyNutritionHistories =
          <DailyNutritionHistory>[];

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
      final num? dailyWeightsGoal = data['dailyWeightsGoal'];
      final num? dailyProteinGoal = data['dailyProteinGoal'];
      final String displayName = data['displayName'];
      final int? backgroundImageIndex = data['backgroundImageIndex'];

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
        displayName: displayName,
        backgroundImageIndex: backgroundImageIndex,
      );
    } else {
      throw 'null';
    }
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
          dailyWorkoutHistories!.map((e) => e.toMap()).toList();
    }
    if (dailyNutritionHistories != null) {
      data['dailyNutritionHistories'] =
          dailyNutritionHistories!.map((e) => e.toMap()).toList();
    }
    data['dailyWeightsGoal'] = dailyWeightsGoal;
    data['dailyProteinGoal'] = dailyProteinGoal;
    data['displayName'] = displayName;
    data['backgroundImageIndex'] = backgroundImageIndex;

    return data;
  }
}

class DailyWorkoutHistory {
  DailyWorkoutHistory({
    required this.date,
    required this.totalWeights,
  });

  final DateTime date;
  final num totalWeights;

  factory DailyWorkoutHistory.fromMap(Map<String, dynamic> data) {
    // if (data == null) {
    //   return null;
    // }
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
  DailyNutritionHistory({
    required this.date,
    required this.totalProteins,
  });

  final DateTime date;
  final double totalProteins;

  factory DailyNutritionHistory.fromMap(Map<String, dynamic> data) {
    // if (data == null) {
    //   return null;
    // }
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
