// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Enumeration class, representing possible styles for the [Border] element.
 */
class BorderStyle
{
  final String _str;

  const BorderStyle(this._str);

  static const none = const BorderStyle('none');
  static const dotted = const BorderStyle('dotted');
  static const dashed = const BorderStyle('dashed');
  static const solid = const BorderStyle('solid');
  static const double = const BorderStyle('double');
  static const groove = const BorderStyle('groove');
  static const ridge = const BorderStyle('ridge');
  static const inset = const BorderStyle('inset');
  static const outset = const BorderStyle('outset');

  String toString() => _str;
}
