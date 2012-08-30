// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to [Location] value.
*/
class StringToLocationConverter implements IValueConverter {
  const StringToLocationConverter();

  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (value is! String) return value;

    switch(value.toLowerCase()){
      case 'left':
        return DockLocation.left;
      case 'right':
        return DockLocation.right;
      case 'top':
        return DockLocation.top;
      case 'bottom':
        return DockLocation.bottom;
      default:
        throw const BuckshotException("Invalid Location value given.");
    }
  }
}
