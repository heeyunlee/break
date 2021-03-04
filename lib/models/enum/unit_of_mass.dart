enum UnitOfMass { kg, lbs }

extension UnitOfMassExtension on UnitOfMass {
  String get label {
    switch (this) {
      case UnitOfMass.kg:
        return 'kg';
      case UnitOfMass.lbs:
        return 'lbs';
      default:
        return null;
    }
  }

  double get multiplyFactor {
    switch (this) {
      case UnitOfMass.kg:
        return 1;
      case UnitOfMass.lbs:
        return 2.205;
      default:
        return null;
    }
  }

  double get dividingFactor {
    switch (this) {
      case UnitOfMass.kg:
        return 2.205;
      case UnitOfMass.lbs:
        return 1;
      default:
        return null;
    }
  }
}
