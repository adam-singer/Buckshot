// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to [Visibility] enumerator.
*/
class StringToVisibilityConverter implements IValueConverter{
  
  const StringToVisibilityConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (value is! String) return value;
    
    switch(value){
      case "visible":
        return Visibility.visible;
      case "collapsed":
        return Visibility.collapsed;
      default:
        return value;
      }
  }
}