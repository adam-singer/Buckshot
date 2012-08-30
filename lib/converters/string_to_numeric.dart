// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to [int] value.
*/
class StringToNumericConverter implements IValueConverter {
  const StringToNumericConverter();

  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (value is! String || value == 'auto') return value;

    try{
      return parseDouble(value);
    }on Exception catch(e){
      return value;
    }
  }
}
