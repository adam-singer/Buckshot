// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* Enumerates vertical alignment values. */
class VerticalAlignment{
  const VerticalAlignment(this._str);
  final String _str;
  static const center = const VerticalAlignment("center");
  static const stretch = const VerticalAlignment("stretch");
  static const top = const VerticalAlignment("top");
  static const bottom = const VerticalAlignment("bottom");
  
  /// Deperecated.  Use .toString()
  String asString() => _str;
  
  String toString() => _str;
}