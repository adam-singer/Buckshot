part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class StringToFrameworkElementConverter implements IValueConverter
{
  const StringToFrameworkElementConverter();

  dynamic convert(dynamic value, [dynamic parameter]){
    if (!(value is String)) return value;

    return (namedElements.containsKey(value)) ? namedElements[value] : null;
  }
}
