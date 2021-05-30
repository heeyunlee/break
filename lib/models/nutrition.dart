import 'package:cloud_firestore/cloud_firestore.dart';

class Nutrition {
  final String nutritionId;
  final String userId;
  final String username;
  final Timestamp loggedTime;
  final DateTime loggedDate;
  final String type;
  final num proteinAmount;
  final String? notes; // Nullable

  const Nutrition({
    required this.nutritionId,
    required this.userId,
    required this.username,
    required this.loggedTime,
    required this.loggedDate,
    required this.type,
    required this.proteinAmount,
    this.notes,
  });

  factory Nutrition.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'];
      final String username = data['username'];
      final Timestamp loggedTime = data['loggedTime'];
      final DateTime loggedDate = data['loggedDate'].toDate();
      final String type = data['type'];
      final num proteinAmount = data['proteinAmount'];
      final String? notes = data['notes'];

      return Nutrition(
        nutritionId: documentId,
        userId: userId,
        username: username,
        loggedTime: loggedTime,
        type: type,
        notes: notes,
        proteinAmount: proteinAmount,
        loggedDate: loggedDate,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'loggedTime': loggedTime,
      'userId': userId,
      'username': username,
      'type': type,
      'notes': notes,
      'proteinAmount': proteinAmount,
      'loggedDate': loggedDate,
    };
  }
}
