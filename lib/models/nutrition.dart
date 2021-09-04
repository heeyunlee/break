import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:workout_player/models/enum/meal.dart';

class Nutrition {
  const Nutrition({
    required this.nutritionId,
    required this.userId,
    required this.username,
    required this.loggedTime,
    required this.loggedDate,
    required this.type,
    required this.proteinAmount,
    this.notes,
    this.calories,
    this.carbs,
    this.fat,
  });

  final String nutritionId;
  final String userId;
  final String username;
  final Timestamp loggedTime;
  final DateTime loggedDate;
  final Meal type;
  final num proteinAmount;
  final String? notes; // Nullable
  final num? calories; // Nullable
  final num? carbs; // Nullable
  final num? fat; // Nullable

  factory Nutrition.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'].toString();
      final String username = data['username'].toString();
      final Timestamp loggedTime = data['loggedTime'] as Timestamp;
      final DateTime loggedDate = (data['loggedDate'] as Timestamp).toDate();

      final Meal type = EnumToString.fromString<Meal>(
        Meal.values,
        data['type'].toString(),
        camelCase: true,
      )!;

      final num proteinAmount = num.parse(data['proteinAmount'].toString());
      final String? notes = data['notes']?.toString();
      final num? calories = num.tryParse(data['calories']?.toString() ?? '');
      final num? carbs = num.tryParse(data['carbs']?.toString() ?? '');
      final num? fat = num.tryParse(data['fat']?.toString() ?? '');

      return Nutrition(
        nutritionId: documentId,
        userId: userId,
        username: username,
        loggedTime: loggedTime,
        type: type,
        notes: notes,
        proteinAmount: proteinAmount,
        loggedDate: loggedDate,
        calories: calories,
        carbs: carbs,
        fat: fat,
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
      'type': EnumToString.convertToString(type, camelCase: true),
      'notes': notes,
      'proteinAmount': proteinAmount,
      'loggedDate': loggedDate,
      'calories': calories,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
