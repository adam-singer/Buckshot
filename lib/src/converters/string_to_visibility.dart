part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to [Visibility] enumerator.
*/
class StringToVisibilityConverter implements IValueConverter{
  
  const StringToVisibilityConverter();
  
  dynamic convert(dynamic value, [dynamic parameter]){
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