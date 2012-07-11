// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides a conversion between [String] and [HorizontalAlignment].
*/
class StringToHorizontalAlignmentConverter implements IValueConverter{
  
  const StringToHorizontalAlignmentConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;
    
    switch(value){
      case "center":
        return HorizontalAlignment.center;
      case "stretch":
        return HorizontalAlignment.stretch;
      case "left":
        return HorizontalAlignment.left;
      case "right":
        return HorizontalAlignment.right;
      default:
        throw new BuckshotException('Invalid horizontalAlignment value "$value".');
    }
  }
}