// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts a [String] to an [Orientation] enumerator.
*/
class StringToOrientationConverter implements IValueConverter{
  
  const StringToOrientationConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;
    switch(value){
      case "horizontal":
        return Orientation.horizontal;
      case "vertical":
        return Orientation.vertical;
      default:
        throw new BuckshotException('Invalid orientation value "$value".');
    }
  } 
}
