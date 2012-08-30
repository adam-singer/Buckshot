// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to a [bool] value.
*/
class StringToBooleanConverter implements IValueConverter
{
  const StringToBooleanConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;
    if (value.toLowerCase() == "false")
    {
      return false;
    }else if (value.toLowerCase() == "true"){
      return true;
    }else{
      throw new BuckshotException("Invalid string passed to boolean converter: '${value}'.");
    }
  }
}
