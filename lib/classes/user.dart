import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  final List<dynamic>? widgetsList; // Nullable
  final Map<String, dynamic>? deviceInfo; // Nullable
  final Timestamp? lastAppOpenedTime; // Nullable
  final DateTime? creationTime; // Nullable
  final String? profileUrl; // Nullable

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
    this.widgetsList,
    this.deviceInfo,
    this.lastAppOpenedTime,
    this.creationTime,
    this.profileUrl,
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
      final List<dynamic>? widgetsList = data['widgetsList'];
      final Map<String, dynamic>? deviceInfo = data['deviceInfo'];
      final Timestamp? lastAppOpenedTime = data['lastAppOpenedTime'];
      final DateTime? creationTime = data['creationTime']?.toDate();
      final String? profileUrl = data['profileUrl'];

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
        widgetsList: widgetsList,
        deviceInfo: deviceInfo,
        lastAppOpenedTime: lastAppOpenedTime,
        creationTime: creationTime,
        profileUrl: profileUrl,
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
    data['widgetsList'] = widgetsList;
    data['deviceInfo'] = deviceInfo;
    data['lastAppOpenedTime'] = lastAppOpenedTime;
    data['creationTime'] = creationTime;
    data['profileUrl'] = profileUrl;

    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userId == userId &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.signUpDate == signUpDate &&
        other.signUpProvider == signUpProvider &&
        listEquals(other.savedWorkouts, savedWorkouts) &&
        listEquals(other.savedRoutines, savedRoutines) &&
        other.totalWeights == totalWeights &&
        other.totalNumberOfWorkouts == totalNumberOfWorkouts &&
        other.unitOfMass == unitOfMass &&
        other.lastLoginDate == lastLoginDate &&
        other.dailyWeightsGoal == dailyWeightsGoal &&
        other.dailyProteinGoal == dailyProteinGoal &&
        other.displayName == displayName &&
        other.backgroundImageIndex == backgroundImageIndex &&
        other.lastHealthDataFetchedTime == lastHealthDataFetchedTime &&
        other.weightGoal == weightGoal &&
        other.bodyFatPercentageGoal == bodyFatPercentageGoal &&
        listEquals(other.widgetsList, widgetsList) &&
        mapEquals(other.deviceInfo, deviceInfo) &&
        other.lastAppOpenedTime == lastAppOpenedTime &&
        other.creationTime == creationTime &&
        other.profileUrl == profileUrl;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        signUpDate.hashCode ^
        signUpProvider.hashCode ^
        savedWorkouts.hashCode ^
        savedRoutines.hashCode ^
        totalWeights.hashCode ^
        totalNumberOfWorkouts.hashCode ^
        unitOfMass.hashCode ^
        lastLoginDate.hashCode ^
        dailyWeightsGoal.hashCode ^
        dailyProteinGoal.hashCode ^
        displayName.hashCode ^
        backgroundImageIndex.hashCode ^
        lastHealthDataFetchedTime.hashCode ^
        weightGoal.hashCode ^
        bodyFatPercentageGoal.hashCode ^
        widgetsList.hashCode ^
        deviceInfo.hashCode ^
        lastAppOpenedTime.hashCode ^
        creationTime.hashCode ^
        profileUrl.hashCode;
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'userId': userId,
  //     'userName': userName,
  //     'userEmail': userEmail,
  //     'signUpDate': signUpDate,
  //     'signUpProvider': signUpProvider,
  //     'savedWorkouts': savedWorkouts,
  //     'savedRoutines': savedRoutines,
  //     'totalWeights': totalWeights,
  //     'totalNumberOfWorkouts': totalNumberOfWorkouts,
  //     'unitOfMass': unitOfMass,
  //     'lastLoginDate': lastLoginDate,
  //     'dailyWeightsGoal': dailyWeightsGoal,
  //     'dailyProteinGoal': dailyProteinGoal,
  //     'displayName': displayName,
  //     'backgroundImageIndex': backgroundImageIndex,
  //     'lastHealthDataFetchedTime': lastHealthDataFetchedTime,
  //     'weightGoal': weightGoal,
  //     'bodyFatPercentageGoal': bodyFatPercentageGoal,
  //     'widgetsList': widgetsList,
  //     'deviceInfo': deviceInfo,
  //     'lastAppOpenedTime': lastAppOpenedTime,
  //     'creationTime': creationTime,
  //     'profileUrl': profileUrl,
  //   };
  // }

  // factory User.fromMap(Map<String, dynamic> map) {
  //   return User(
  //     userId: map['userId'],
  //     userName: map['userName'],
  //     userEmail: map['userEmail'],
  //     signUpDate: map['signUpDate'],
  //     signUpProvider: map['signUpProvider'],
  //     savedWorkouts: List<String>.from(map['savedWorkouts']),
  //     savedRoutines: List<String>.from(map['savedRoutines']),
  //     totalWeights: map['totalWeights'],
  //     totalNumberOfWorkouts: map['totalNumberOfWorkouts'],
  //     unitOfMass: map['unitOfMass'],
  //     lastLoginDate: map['lastLoginDate'],
  //     dailyWeightsGoal: map['dailyWeightsGoal'],
  //     dailyProteinGoal: map['dailyProteinGoal'],
  //     displayName: map['displayName'],
  //     backgroundImageIndex: map['backgroundImageIndex'],
  //     lastHealthDataFetchedTime:
  //         DateTime.fromMillisecondsSinceEpoch(map['lastHealthDataFetchedTime']),
  //     weightGoal: map['weightGoal'],
  //     bodyFatPercentageGoal: map['bodyFatPercentageGoal'],
  //     widgetsList: List<String>.from(map['widgetsList']),
  //     deviceInfo: Map<String, dynamic>.from(map['deviceInfo']),
  //     lastAppOpenedTime: map['lastAppOpenedTime'],
  //     creationTime: DateTime.fromMillisecondsSinceEpoch(map['creationTime']),
  //     profileUrl: map['profileUrl'],
  //   );
  // }

  // Map<String, dynamic>? toJson() => toMap();

  // factory User.fromJson(Map<String, dynamic>? source) => User.fromMap(source!);
}