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
  final num? dailyWeightsGoal; // Nullable
  final num? dailyProteinGoal; // Nullable
  final String displayName;
  final int? backgroundImageIndex; // Nullable
  final DateTime? lastHealthDataFetchedTime; // Nullable
  final num? weightGoal; // Nullable
  final num? bodyFatPercentageGoal; // Nullable

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
    this.dailyWeightsGoal,
    this.dailyProteinGoal,
    required this.displayName,
    this.backgroundImageIndex,
    this.lastHealthDataFetchedTime,
    this.weightGoal,
    this.bodyFatPercentageGoal,
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
      final num? dailyWeightsGoal = data['dailyWeightsGoal'];
      final num? dailyProteinGoal = data['dailyProteinGoal'];
      final String displayName = data['displayName'];
      final int? backgroundImageIndex = data['backgroundImageIndex'];
      final DateTime? lastHealthDataFetchedTime =
          data['lastHealthDataFetchedTime']?.toDate();
      final num? weightGoal = data['weightGoal'];
      final num? bodyFatPercentageGoal = data['bodyFatPercentageGoal'];

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
        dailyWeightsGoal: dailyWeightsGoal,
        dailyProteinGoal: dailyProteinGoal,
        displayName: displayName,
        backgroundImageIndex: backgroundImageIndex,
        lastHealthDataFetchedTime: lastHealthDataFetchedTime,
        weightGoal: weightGoal,
        bodyFatPercentageGoal: bodyFatPercentageGoal,
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
    data['dailyWeightsGoal'] = dailyWeightsGoal;
    data['dailyProteinGoal'] = dailyProteinGoal;
    data['displayName'] = displayName;
    data['backgroundImageIndex'] = backgroundImageIndex;
    data['lastHealthDataFetchedTime'] = lastHealthDataFetchedTime;
    data['weightGoal'] = weightGoal;
    data['bodyFatPercentageGoal'] = bodyFatPercentageGoal;

    return data;
  }
}
