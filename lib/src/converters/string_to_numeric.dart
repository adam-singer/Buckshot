part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Converts from [String] to [int] value.
*/
class StringToNumericConverter implements IValueConverter {
  const StringToNumericConverter();

  dynamic convert(dynamic value, {dynamic parameter}){
    if (value is! String || value == 'auto') return value;

    try{
      return double.parse(value);
    } catch(e){
      return value;
    }
  }
}
