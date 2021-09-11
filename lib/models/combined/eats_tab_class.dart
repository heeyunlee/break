import 'package:workout_player/models/models.dart';

class EatsTabClass {
  final User user;
  final List<Nutrition> thisWeeksNutritions;
  final List<Nutrition> recentNutritions;

  const EatsTabClass({
    required this.user,
    required this.thisWeeksNutritions,
    required this.recentNutritions,
  });
}
