import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';

class FoodItem {
  const FoodItem({
    required this.foodItemId,
    required this.name,
    required this.calories,
    required this.unitOfMass,
    this.fats,
    this.saturatedFat,
    this.transFat,
    this.cholesterol,
    this.totalCarbs,
    this.dietaryFiber,
    this.totalSugar,
    this.proteins,
  });

  final String foodItemId;
  final String name;
  final num calories;
  final UnitOfMass unitOfMass;
  final num? fats;
  final num? saturatedFat;
  final num? transFat;
  final num? cholesterol;
  final num? totalCarbs;
  final num? dietaryFiber;
  final num? totalSugar;
  final num? proteins;

  Map<String, dynamic> toMap() {
    return {
      'foodItemId': foodItemId,
      'name': name,
      'calories': calories,
      'unitOfMass': EnumToString.convertToString(unitOfMass),
      'fats': fats,
      'saturatedFat': saturatedFat,
      'transFat': transFat,
      'cholesterol': cholesterol,
      'totalCarbs': totalCarbs,
      'dietaryFiber': dietaryFiber,
      'totalSugar': totalSugar,
      'proteins': proteins,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      foodItemId: map['foodItemId'],
      name: map['name'],
      calories: map['calories'],
      unitOfMass: EnumToString.fromString(
        UnitOfMass.values,
        map['unitOfMass'],
      )!,
      fats: map['fats'],
      saturatedFat: map['saturatedFat'],
      transFat: map['transFat'],
      cholesterol: map['cholesterol'],
      totalCarbs: map['totalCarbs'],
      dietaryFiber: map['dietaryFiber'],
      totalSugar: map['totalSugar'],
      proteins: map['proteins'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodItem.fromJson(String source) =>
      FoodItem.fromMap(json.decode(source));
}
