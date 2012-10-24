part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates [FrameworkElement] horizontal alignment values. */
class HorizontalAlignment{
  const HorizontalAlignment(this._str);
  final String _str;
  
  static const center = const HorizontalAlignment("center");
  static const stretch = const HorizontalAlignment("stretch");
  static const left = const HorizontalAlignment("left");
  static const right = const HorizontalAlignment("right");

  String asString() => _str;
  
  String toString() => asString();
}
