library random_stuff_library;

import 'dart:math';

/**
 * This model produces various random pieces of information.
 */
class RandomStuff
{
  const WORD_LIST =
      const ['apple', 'pear', 'corn', 'buckshot', 'juice', 'dart', 'car',
             'toy', 'fun', 'html5', 'css3', 'chess', 'soccer', 'chelsea',
             'android', 'galaxy', 'stars'];

  const COLORS =
      const ['Black', 'Red', 'Green', 'Blue', 'Yellow', 'Orange', 'Purple'];

  final _rng = new Random();

  /** Returns a random word from a list of words. */
  Future<String> nextWord() =>
      new Future.immediate(WORD_LIST[_rng.nextInt(WORD_LIST.length)]);

  /** Returns a random integer between 0 and 255. */
  Future<int> nextInt() => new Future.immediate(_rng.nextInt(256));

  /** Returns a color String from a list of colors. */
  Future<String> nextColor() =>
      new Future.immediate(COLORS[_rng.nextInt(COLORS.length)]);

}
