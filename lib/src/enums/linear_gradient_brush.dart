part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* Enumerates possible [LinearGradientBrush] directions.
*
* ## See Also
* * [Brush]
* * [RadialGradientDrawMode]
*/
class LinearGradientDirection {
final String _str;

const LinearGradientDirection(this._str);

static const vertical = const LinearGradientDirection("top");
static const horizontal = const LinearGradientDirection("left");

String toString() => _str;
}

/**
* Converts a string value to a [LinearGradientDirection] enumeration.
*/
class StringToLinearGradientDirectionConverter implements IValueConverter{
  const StringToLinearGradientDirectionConverter();
  
  dynamic convert(dynamic value, [dynamic parameter]){
    if (!(value is String)) return value;
    
    switch(value){
      case "vertical":
        return LinearGradientDirection.vertical;
      case "horizontal":
        return LinearGradientDirection.horizontal;
    }
  }
}
