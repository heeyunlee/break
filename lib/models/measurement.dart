import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_player/view_models/main_model.dart';

/// Class of `Measurement` is a collection of body measurements such as [bodyWeight],
/// [bodyFat], [skeletalMuscleMass], [bmi].
///
/// It also includes [loggedTime] and [loggedDate]
class Measurement {
  const Measurement({
    required this.measurementId,
    required this.userId,
    required this.username,
    required this.loggedTime,
    required this.loggedDate,
    this.bodyWeight,
    this.bodyFat,
    this.skeletalMuscleMass,
    this.bmi,
    this.notes,
    this.dataSource,
    this.sourceId,
    this.sourceName,
    this.dataType,
    this.platformType,
  });

  final String measurementId;
  final String userId;
  final String username;
  final Timestamp loggedTime;
  final DateTime loggedDate;
  final num? bodyWeight;
  final num? bodyFat; // Nullable
  final num? skeletalMuscleMass; // Nullable
  final num? bmi; // Nullable
  final String? notes; // Nullables
  final String? dataSource; // Nullables
  final String? sourceId;
  final String? sourceName;
  final String? dataType;
  final String? platformType;

  factory Measurement.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'].toString();
      final String username = data['username'].toString();
      final Timestamp loggedTime = data['loggedTime'] as Timestamp;
      final DateTime loggedDate = (data['loggedDate'] as Timestamp).toDate();
      final num? bodyWeight = num.tryParse(data['bodyWeight'].toString());
      final num? bodyFat = num.tryParse(data['bodyFat'].toString());
      final num? skeletalMuscleMass =
          num.tryParse(data['skeletalMuscleMass'].toString());
      final num? bmi = num.tryParse(data['bmi'].toString());
      final String? notes = data['notes']?.toString();
      final String? dataSource = data['dataSource']?.toString();
      final String? sourceId = data['sourceId']?.toString();
      final String? sourceName = data['sourceName']?.toString();
      final String? dataType = data['dataType']?.toString();
      final String? platformType = data['platformType']?.toString();

      final measurement = Measurement(
        measurementId: documentId,
        userId: userId,
        username: username,
        loggedTime: loggedTime,
        loggedDate: loggedDate,
        bodyWeight: bodyWeight,
        bodyFat: bodyFat,
        skeletalMuscleMass: skeletalMuscleMass,
        bmi: bmi,
        notes: notes,
        dataSource: dataSource,
        sourceId: sourceId,
        sourceName: sourceName,
        dataType: dataType,
        platformType: platformType,
      );

      return measurement;
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'loggedTime': loggedTime,
      'loggedDate': loggedDate,
      'bodyWeight': bodyWeight,
      'bodyFat': bodyFat,
      'skeletalMuscleMass': skeletalMuscleMass,
      'bmi': bmi,
      'notes': notes,
      'dataSource': dataSource,
      'sourceId': sourceId,
      'sourceName': sourceName,
      'dataType': dataType,
      'platformType': platformType,
    };
  }

  Measurement copyWith({
    String? measurementId,
    String? userId,
    String? username,
    Timestamp? loggedTime,
    DateTime? loggedDate,
    num? bodyWeight,
    num? bodyFat,
    num? skeletalMuscleMass,
    num? bmi,
    String? notes,
    String? dataSource,
    String? sourceId,
    String? sourceName,
    String? dataType,
    String? platformType,
  }) {
    return Measurement(
      measurementId: measurementId ?? this.measurementId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      loggedTime: loggedTime ?? this.loggedTime,
      loggedDate: loggedDate ?? this.loggedDate,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      bodyFat: bodyFat ?? this.bodyFat,
      skeletalMuscleMass: skeletalMuscleMass ?? this.skeletalMuscleMass,
      bmi: bmi ?? this.bmi,
      notes: notes ?? this.notes,
      dataSource: dataSource ?? this.dataSource,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      dataType: dataType ?? this.dataType,
      platformType: platformType ?? this.platformType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Measurement &&
        other.measurementId == measurementId &&
        other.userId == userId &&
        other.username == username &&
        other.loggedTime == loggedTime &&
        other.loggedDate == loggedDate &&
        other.bodyWeight == bodyWeight &&
        other.bodyFat == bodyFat &&
        other.skeletalMuscleMass == skeletalMuscleMass &&
        other.bmi == bmi &&
        other.notes == notes &&
        other.dataSource == dataSource &&
        other.sourceId == sourceId &&
        other.sourceName == sourceName &&
        other.dataType == dataType &&
        other.platformType == platformType;
  }

  @override
  int get hashCode {
    return measurementId.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        loggedTime.hashCode ^
        loggedDate.hashCode ^
        bodyWeight.hashCode ^
        bodyFat.hashCode ^
        skeletalMuscleMass.hashCode ^
        bmi.hashCode ^
        notes.hashCode ^
        dataSource.hashCode ^
        sourceId.hashCode ^
        sourceName.hashCode ^
        dataType.hashCode ^
        platformType.hashCode;
  }
}

class LatestUserMeasurement {
  final String latestUserMeasurementId;
  final num? weight;
  final DateTime? latestWeightUpdateTime;
  final num? bodyFat;
  final DateTime? latestBodyFatUpdateTime;
  final num? skeletalMuscleMass;
  final DateTime? latestskeletalMuscleMassUpdateTime;
  final num? bmi;
  final DateTime? latestBmiUpdateTime;

  const LatestUserMeasurement({
    required this.latestUserMeasurementId,
    this.weight,
    this.latestWeightUpdateTime,
    this.bodyFat,
    this.latestBodyFatUpdateTime,
    this.skeletalMuscleMass,
    this.latestskeletalMuscleMassUpdateTime,
    this.bmi,
    this.latestBmiUpdateTime,
  });
}
