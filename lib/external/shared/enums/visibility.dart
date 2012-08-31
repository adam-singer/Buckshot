// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates visibility states. */
class Visibility{ 
  const Visibility(this._str);
  final String _str;
  static final visible = const Visibility('visible');
  static final collapsed = const Visibility('hidden');
  
  String toString() => _str;
}
