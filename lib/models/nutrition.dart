import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/food_item.dart';

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
    required this.description,
    required this.isCreditCardTransaction,
    this.foodItems,
    this.merchantName,
    this.unitOfMass,
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
  final String? description;
  final bool? isCreditCardTransaction;
  final List<FoodItem>? foodItems;
  final String? merchantName;
  final UnitOfMass? unitOfMass;

  factory Nutrition.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'] as String;
      final String username = data['username'] as String;
      final Timestamp loggedTime = data['loggedTime'] as Timestamp;
      final DateTime loggedDate =
          (data['loggedDate'] as Timestamp).toDate().toUtc();

      final Meal type = EnumToString.fromString<Meal>(
        Meal.values,
        data['type'] as String,
        camelCase: true,
      )!;

      final num proteinAmount = data['proteinAmount'] as num;
      final String? notes = data['notes'] as String?;
      final num? calories = data['calories'] as num?;
      final num? carbs = data['carbs'] as num?;
      final num? fat = data['fat'] as num?;
      final String? description = data['description'] as String?;
      final bool? isCreditCardTransaction =
          data['isCreditCardTransaction'] as bool?;
      final List<FoodItem>? foodItems = data['foodItems']
          ?.map<FoodItem>((item) => FoodItem.fromMap(item))
          .toList();
      final String? merchantName = data['merchantName'] as String?;
      final UnitOfMass? unitOfMass = (data['unitOfMass'] != null)
          ? EnumToString.fromString(UnitOfMass.values, data['unitOfMass'])
          : null;

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
        description: description,
        isCreditCardTransaction: isCreditCardTransaction,
        foodItems: foodItems,
        merchantName: merchantName,
        unitOfMass: unitOfMass,
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
      'description': description,
      'isCreditCardTransaction': isCreditCardTransaction,
      'foodItems': foodItems?.map((e) => e.toJson()).toList(),
      'merchantName': merchantName,
      'unitOfMass': EnumToString.convertToString(unitOfMass, camelCase: true),
    };
  }
}
