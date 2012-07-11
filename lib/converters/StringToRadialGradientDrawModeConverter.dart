// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class StringToRadialGradientDrawModeConverter implements IValueConverter {

  const StringToRadialGradientDrawModeConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;
    
    switch(value){
      case "cover":
        return RadialGradientDrawMode.cover;
      case "contain":
        return RadialGradientDrawMode.contain;
      default:
        throw const BuckshotException("Invalid string value. Unable to convert to RadialGradientDrawMode.");
    }
  }
}
