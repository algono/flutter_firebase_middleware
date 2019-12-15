import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase_middleware/MultipleCollectionStreamSystem.dart';

void main() {
  test('combines multiple streams together', () async {
    final system = MultipleCollectionStreamSystem<int, double>();
    final period = Duration(milliseconds: 50);

    final streamOneExpectedResult = Random().nextDouble();
    final streamTwoExpectedResult = Random().nextDouble() + 2.0;

    final streamOne = Stream.periodic(period, (_) => streamOneExpectedResult);
    final streamTwo = Stream.periodic(period, (_) => streamTwoExpectedResult);

    system.add(1, streamOne);
    system.add(2, streamTwo);

    final subscription = system.stream.listen((streams) async {
      expect(streams[1], streamOneExpectedResult);
      expect(streams[2], streamTwoExpectedResult);

      system.dispose(); // Also closes the stream controller

      // Checks that the stream was actually closed correctly
      expect(system.stream.first, throwsStateError);
    }, cancelOnError: true);

    await subscription.asFuture();
    await subscription.cancel();
  });
}
