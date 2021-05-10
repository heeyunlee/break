enum UnitOfMass { kg, lbs }

extension UnitOfMassExtension on UnitOfMass {
  String? get label {
    switch (this) {
      case UnitOfMass.kg:
        return 'kg';
      case UnitOfMass.lbs:
        return 'lbs';
      default:
        return null;
    }
  }
}
