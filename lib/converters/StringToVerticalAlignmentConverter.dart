// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to [VerticalAlignment] enumerator.
*/
class StringToVerticalAlignmentConverter implements IValueConverter{
  
  const StringToVerticalAlignmentConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;
    switch(value){
    case "center":
      return VerticalAlignment.center;
    case "stretch":
      return VerticalAlignment.stretch;
    case "top":
      return VerticalAlignment.top;
    case "bottom":
       return VerticalAlignment.bottom;
    default:
      throw new BuckshotException('Invalid verticalAlignment value "$value".');
    }
  }
}