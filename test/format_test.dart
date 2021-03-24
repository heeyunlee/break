import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_player/format.dart';

void main() {
  group('weights', () {
    test('3digit', () {
      expect(Format.weights(123), '123');
    });
    test('6digit', () {
      expect(Format.weights(123456), '123,456');
    });
    test('9digit', () {
      expect(Format.weights(123456789), '123,456,789');
    });
    test('12digit', () {
      expect(Format.weights(123456789123), '123,456,789,123');
    });
    test('decimal', () {
      expect(Format.weights(123.123), '123.1');
    });
  });

  // group('time difference', () {
  //   test('seconds', () {
  //     expect(
  //       Format.timeDifference(
  //           Timestamp.now().toDate().subtract(Duration(seconds: 5))),
  //       '5초 전',
  //     );
  //   });

  //   test('minutes', () {
  //     expect(
  //         Format.timeDifference(
  //             Timestamp.now().toDate().subtract(Duration(minutes: 5))),
  //         '5분 전');
  //   });

  //   test('hours', () {
  //     expect(
  //         Format.timeDifference(
  //             Timestamp.now().toDate().subtract(Duration(hours: 5))),
  //         '5시간 전');
  //   });

  //   test('days', () {
  //     expect(
  //         Format.timeDifference(
  //             Timestamp.now().toDate().subtract(Duration(days: 5))),
  //         '5일 전');
  //   });
  // });
}
