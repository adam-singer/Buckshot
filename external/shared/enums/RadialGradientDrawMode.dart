// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates possible [RadialGradientBrush] draw modes.
* 
* ## See Also
* * [LinearGradientDirection]
*/
class RadialGradientDrawMode {
  final String _str;
  
  const RadialGradientDrawMode(this._str);
  
  static final contain = const RadialGradientDrawMode("contain");
  static final cover = const RadialGradientDrawMode("cover");
  
  String toString() => _str;
}


