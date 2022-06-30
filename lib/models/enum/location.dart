import 'package:workout_player/generated/l10n.dart';

enum Location {
  atHome,
  gym,
  outdoor,
  others,
}

extension LocationTranslationExtension on Location {
  String? get translation {
    switch (this) {
      case Location.atHome:
        return S.current.atHome;
      case Location.gym:
        return S.current.gym;
      case Location.outdoor:
        return S.current.outdoor;
      case Location.others:
        return S.current.others;
      default:
        return null;
    }
  }
}

extension LocationList on Location {
  List<String> get list {
    final List<String> locationList = [];
    for (var i = 0; i < Location.values.length; i++) {
      final value = Location.values[i].toString();
      locationList.add(value);
    }
    return locationList;
  }
}

extension LocationTranslatedList on Location {
  List<String> get translatedList {
    final List<String> locationList = [];
    for (var i = 0; i < Location.values.length; i++) {
      final value = Location.values[i].translation;
      locationList.add(value!);
    }
    return locationList;
  }
}
