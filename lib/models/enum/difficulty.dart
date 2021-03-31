// TODO: Add Translation

enum Difficulty {
  Beginner,
  Intermediate,
  Advanced,
}

extension DifficultyExtension on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.Beginner:
        return 'Beginner';
      case Difficulty.Intermediate:
        return 'Intermediate';
      case Difficulty.Advanced:
        return 'Advanced';
      default:
        return null;
    }
  }
}
