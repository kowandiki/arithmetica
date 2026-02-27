
import 'dart:math';

class Util {

  /// returns a value between 0 and 1, scaled and offset by sigma and mean respectively.
  /// follows a gaussian distribution with heavier weighting towards the middle
  static double nextGaussian(Random random, {double mean = 0, double sigma = 1, double clampStd = 2}) {
    // use box-muller transform
    double u1 = random.nextDouble();
    double u2 = random.nextDouble();
    double z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2);

    // scale to between 0 and 1, distorts distribution slightly supposedly but does not really matter here
    double result = 1.0 / (1.0 + exp(-z0));

    return result * sigma + mean;
  }

  /// Returns a random number following a gaussian distribution in the form of an int
  static int nextGaussianInt(Random random, {double mean = 0, double sigma = 1}) {
    return nextGaussian(random, mean:mean, sigma:sigma).floor();
  }

  static double clampd(double lower, double upper, double val) {
    if (val < lower) {
      return lower;
    }
    if (val > upper) {
      return upper;
    }
    return val;
  }

  static int clampi(int lower, int upper, int val) {
    if (val < lower) {
      return lower;
    }
    if (val > upper) {
      return upper;
    }
    return val;
  }

  static List<int> getFactors(int n, {bool excludeOnes = false}) {

    List<int> factors = [];

    for (int i = excludeOnes ? 2 : 1; i <= n ~/ 2; i++) {
      if (n % i == 0) {
        factors.add(i);
      }
    }

    // if the number is prime 1 is the only factor so add it back in if excludeOnes caused it to not be added
    if (factors.isEmpty) {
      factors.add(1);
    }

    return factors;
  }
}