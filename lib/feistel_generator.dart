import 'dart:math';

class FeistelGenerator {
  final int n;
  final int rounds;
  final int mask;
  final List<int> keys;
  int counter = 0;

  FeistelGenerator(this.n, {this.rounds = 4, int? seed})
      : mask = _nextPowerOfTwo(n) - 1,
        keys = _generateKeys(rounds, seed);

  static int _nextPowerOfTwo(int x) {
    int p = 1;
    while (p < x) {
      p <<= 1;
    }
    return p;
  }

  static List<int> _generateKeys(int rounds, int? seed) {
    final r = Random(seed);
    return List.generate(rounds, (_) => r.nextInt(1 << 30));
  }

  int _roundFunction(int r, int key) {
    int x = r ^ key;
    x = (x * 0x45d9f3b) & 0xffffffff;
    x ^= (x >> 16);
    return x;
  }

  int _permute(int x) {
    int halfBits = (mask.bitLength ~/ 2);
    int leftMask = (1 << halfBits) - 1;

    int left = x >> halfBits;
    int right = x & leftMask;

    for (int i = 0; i < rounds; i++) {
      int newLeft = right;
      int f = _roundFunction(right, keys[i]) & leftMask;
      int newRight = left ^ f;

      left = newLeft;
      right = newRight;
    }

    return ((left << halfBits) | right) & mask;
  }

  Iterable<int> next() sync* {
    while (counter <= mask) {
      int x = counter++;
      int y = _permute(x);

      if (y < n) {
        yield y;
      }
    }
  }
}
