part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates orientation values. */
class Orientation
{
  const Orientation(this._str);
  final String _str;
  static const horizontal = const Orientation("horizontal");
  static const vertical = const Orientation("vertical");
  
  String toString() => _str;
}