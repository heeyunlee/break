import 'package:json_annotation/json_annotation.dart';

enum UnitOfMass {
  @JsonValue('kilograms')
  kilograms,

  @JsonValue('pounds')
  pounds,

  // @JsonValue('stones')
  // stones,
}

extension UnitOfMassExtension on UnitOfMass {
  String get label {
    switch (this) {
      case UnitOfMass.kilograms:
        return 'kg';
      case UnitOfMass.pounds:
        return 'lbs';
      // case UnitOfMass.stones:
      //   return 'st';
      default:
        return 'kg';
    }
  }
}

extension UnitOfMassGramLabelExtension on UnitOfMass {
  String get gram {
    switch (this) {
      case UnitOfMass.kilograms:
        return 'g';
      case UnitOfMass.pounds:
        return 'lbs';
      // case UnitOfMass.stones:
      //   return 'lb';
      default:
        return 'g';
    }
  }
}

extension UnitOfMassTonLabelExtension on UnitOfMass {
  String? get ton {
    switch (this) {
      case UnitOfMass.kilograms:
        return 't';
      case UnitOfMass.pounds:
        return 'lbs';
      // case UnitOfMass.stones:
      //   return 'st';
      default:
        return null;
    }
  }
}
