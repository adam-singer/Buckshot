// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates [FrameworkElement] horizontal alignment values. */
class HorizontalAlignment{
  const HorizontalAlignment(this._str);
  final String _str;
  
  static final center = const HorizontalAlignment("center");
  static final stretch = const HorizontalAlignment("stretch");
  static final left = const HorizontalAlignment("left");
  static final right = const HorizontalAlignment("right");

  String asString() => _str;
  
  String toString() => asString();
}
