import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

import 'package:workout_player/models/enum/unit_of_mass.dart';

class User {
  final String userId;
  final String userName;
  final String? userEmail; // Nullable
  final Timestamp signUpDate;
  final String signUpProvider;
  final List<String>? savedWorkouts; // Nullable
  final List<String>? savedRoutines; // Nullable
  final num totalWeights;
  final int totalNumberOfWorkouts;
  final int? unitOfMass; // Nullable
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
  final UnitOfMass? unitOfMassEnum; // Nullable
  final num? dailyCarbsGoal; // Nullable
  final num? dailyFatGoal; // Nullable
  final num? dailyCalorieConsumptionGoal; // Nullable
  final bool? isConnectedToPlaid;

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
    this.unitOfMass,
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
    this.unitOfMassEnum,
    this.dailyCarbsGoal,
    this.dailyFatGoal,
    this.dailyCalorieConsumptionGoal,
    this.isConnectedToPlaid,
  });

  factory User.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userName = data['userName'].toString();
      final String? userEmail = data['userEmail']?.toString();
      final Timestamp signUpDate = data['signUpDate'] as Timestamp;
      final String signUpProvider = data['signUpProvider'].toString();
      final List<String>? savedWorkouts = (data['savedWorkouts'] as List?)
          ?.map<String>((e) => e.toString())
          .toList();

      final List<String>? savedRoutines = (data['savedRoutines'] as List?)
          ?.map<String>((e) => e.toString())
          .toList();

      final num totalWeights = num.parse(data['totalWeights'].toString());
      final int totalNumberOfWorkouts =
          int.parse(data['totalNumberOfWorkouts'].toString());
      final int? unitOfMass =
          int.tryParse(data['unitOfMass']?.toString() ?? '');
      final Timestamp lastLoginDate = data['lastLoginDate'] as Timestamp;
      final num? dailyWeightsGoal =
          num.tryParse(data['dailyWeightsGoal']?.toString() ?? '');
      final num? dailyProteinGoal =
          num.tryParse(data['dailyProteinGoal']?.toString() ?? '');
      final String displayName = data['displayName'].toString();
      final int? backgroundImageIndex =
          int.tryParse(data['backgroundImageIndex']?.toString() ?? '');
      final DateTime? lastHealthDataFetchedTime =
          (data['lastHealthDataFetchedTime'] as Timestamp?)?.toDate();

      final num? weightGoal =
          num.tryParse(data['weightGoal']?.toString() ?? '');
      final num? bodyFatPercentageGoal =
          num.tryParse(data['bodyFatPercentageGoal']?.toString() ?? '');
      final List<dynamic>? widgetsList = data['widgetsList'] as List?;
      final Map<String, dynamic>? deviceInfo =
          data['deviceInfo'] as Map<String, dynamic>?;
      final Timestamp? lastAppOpenedTime =
          data['lastAppOpenedTime'] as Timestamp?;
      final DateTime? creationTime =
          (data['creationTime'] as Timestamp?)?.toDate();

      final String? profileUrl = data['profileUrl']?.toString();
      final UnitOfMass? unitOfMassEnum = (data['unitOfMassEnum'] != null)
          ? EnumToString.fromString<UnitOfMass>(
              UnitOfMass.values,
              data['unitOfMassEnum']?.toString() ?? '',
            )
          : null;
      final num? dailyCarbsGoal =
          num.tryParse(data['dailyCarbsGoal']?.toString() ?? '');
      final num? dailyFatGoal =
          num.tryParse(data['dailyFatGoal']?.toString() ?? '');
      final num? dailyCalorieConsumptionGoal =
          num.tryParse(data['dailyCalorieConsumptionGoal']?.toString() ?? '');
      final bool? isConnectedToPlaid = data['isConnectedToPlaid'] as bool?;

      final User user = User(
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
        unitOfMassEnum: unitOfMassEnum,
        dailyCarbsGoal: dailyCarbsGoal,
        dailyFatGoal: dailyFatGoal,
        dailyCalorieConsumptionGoal: dailyCalorieConsumptionGoal,
        isConnectedToPlaid: isConnectedToPlaid,
      );

      return user;
    } else {
      throw UnimplementedError();
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
    data['unitOfMassEnum'] = EnumToString.convertToString(unitOfMassEnum);
    data['dailyCarbsGoal'] = dailyCarbsGoal;
    data['dailyFatGoal'] = dailyFatGoal;
    data['dailyCalorieConsumptionGoal'] = dailyCalorieConsumptionGoal;
    data['isConnectedToPlaid'] = isConnectedToPlaid;

    return data;
  }

  User copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    Timestamp? signUpDate,
    String? signUpProvider,
    List<String>? savedWorkouts,
    List<String>? savedRoutines,
    num? totalWeights,
    int? totalNumberOfWorkouts,
    int? unitOfMass,
    Timestamp? lastLoginDate,
    num? dailyWeightsGoal,
    num? dailyProteinGoal,
    String? displayName,
    int? backgroundImageIndex,
    DateTime? lastHealthDataFetchedTime,
    num? weightGoal,
    num? bodyFatPercentageGoal,
    List<dynamic>? widgetsList,
    Map<String, dynamic>? deviceInfo,
    Timestamp? lastAppOpenedTime,
    DateTime? creationTime,
    String? profileUrl,
    UnitOfMass? unitOfMassEnum,
    num? dailyCarbsGoal,
    num? dailyFatGoal,
    num? dailyCalorieConsumptionGoal,
    bool? isConnectedToPlaid,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      signUpDate: signUpDate ?? this.signUpDate,
      signUpProvider: signUpProvider ?? this.signUpProvider,
      savedWorkouts: savedWorkouts ?? this.savedWorkouts,
      savedRoutines: savedRoutines ?? this.savedRoutines,
      totalWeights: totalWeights ?? this.totalWeights,
      totalNumberOfWorkouts:
          totalNumberOfWorkouts ?? this.totalNumberOfWorkouts,
      unitOfMass: unitOfMass ?? this.unitOfMass,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      dailyWeightsGoal: dailyWeightsGoal ?? this.dailyWeightsGoal,
      dailyProteinGoal: dailyProteinGoal ?? this.dailyProteinGoal,
      displayName: displayName ?? this.displayName,
      backgroundImageIndex: backgroundImageIndex ?? this.backgroundImageIndex,
      lastHealthDataFetchedTime:
          lastHealthDataFetchedTime ?? this.lastHealthDataFetchedTime,
      weightGoal: weightGoal ?? this.weightGoal,
      bodyFatPercentageGoal:
          bodyFatPercentageGoal ?? this.bodyFatPercentageGoal,
      widgetsList: widgetsList ?? this.widgetsList,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      lastAppOpenedTime: lastAppOpenedTime ?? this.lastAppOpenedTime,
      creationTime: creationTime ?? this.creationTime,
      profileUrl: profileUrl ?? this.profileUrl,
      unitOfMassEnum: unitOfMassEnum ?? this.unitOfMassEnum,
      dailyCarbsGoal: dailyCarbsGoal ?? this.dailyCarbsGoal,
      dailyFatGoal: dailyFatGoal ?? this.dailyFatGoal,
      dailyCalorieConsumptionGoal:
          dailyCalorieConsumptionGoal ?? this.dailyCalorieConsumptionGoal,
      isConnectedToPlaid: isConnectedToPlaid ?? this.isConnectedToPlaid,
    );
  }

  @override
  String toString() {
    return 'User(userId: $userId, userName: $userName, userEmail: $userEmail, signUpDate: $signUpDate, signUpProvider: $signUpProvider, savedWorkouts: $savedWorkouts, savedRoutines: $savedRoutines, totalWeights: $totalWeights, totalNumberOfWorkouts: $totalNumberOfWorkouts, unitOfMass: $unitOfMass, lastLoginDate: $lastLoginDate, dailyWeightsGoal: $dailyWeightsGoal, dailyProteinGoal: $dailyProteinGoal, displayName: $displayName, backgroundImageIndex: $backgroundImageIndex, lastHealthDataFetchedTime: $lastHealthDataFetchedTime, weightGoal: $weightGoal, bodyFatPercentageGoal: $bodyFatPercentageGoal, widgetsList: $widgetsList, deviceInfo: $deviceInfo, lastAppOpenedTime: $lastAppOpenedTime, creationTime: $creationTime, profileUrl: $profileUrl, unitOfMassEnum: $unitOfMassEnum, dailyCarbsGoal: $dailyCarbsGoal, dailyFatGoal: $dailyFatGoal, dailyCalorieConsumptionGoal: $dailyCalorieConsumptionGoal, isConnectedToPlaid: $isConnectedToPlaid)';
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
        other.profileUrl == profileUrl &&
        other.unitOfMassEnum == unitOfMassEnum &&
        other.dailyCarbsGoal == dailyCarbsGoal &&
        other.dailyFatGoal == dailyFatGoal &&
        other.dailyCalorieConsumptionGoal == dailyCalorieConsumptionGoal &&
        other.isConnectedToPlaid == isConnectedToPlaid;
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
        profileUrl.hashCode ^
        unitOfMassEnum.hashCode ^
        dailyCarbsGoal.hashCode ^
        dailyFatGoal.hashCode ^
        dailyCalorieConsumptionGoal.hashCode ^
        isConnectedToPlaid.hashCode;
  }
}
