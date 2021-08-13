import 'package:flutter_test/flutter_test.dart';
import 'package:workout_player/utils/formatter.dart';

void main() {
  group('numWithoutDecimal', () {
    test('3digit', () {
      expect(Formatter.numWithoutDecimal(123), '123');
    });
    test('6digit', () {
      expect(Formatter.numWithoutDecimal(123456), '123,456');
    });
    test('9digit', () {
      expect(Formatter.numWithoutDecimal(123456789), '123,456,789');
    });
    test('12digit', () {
      expect(Formatter.numWithoutDecimal(123456789123), '123,456,789,123');
    });
    test('decimal', () {
      expect(Formatter.numWithoutDecimal(123.123), '123');
    });
  });
}
