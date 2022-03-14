import 'dart:math' as math;

extension ListExtension<T> on List<double> {
  double get max => reduce(math.max);
}
