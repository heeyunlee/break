extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

String enumToString(enumItem) => enumItem.toString().split('.').last;
