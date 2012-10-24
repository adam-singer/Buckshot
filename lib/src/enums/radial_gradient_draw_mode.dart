part of core_buckshotui_org;

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
  
  static const contain = const RadialGradientDrawMode("contain");
  static const cover = const RadialGradientDrawMode("cover");
  
  String toString() => _str;
}


