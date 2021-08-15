import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class AuthAndDatabase {
  final Database database;
  final AuthBase auth;

  const AuthAndDatabase({
    required this.database,
    required this.auth,
  });
}
