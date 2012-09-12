// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class StringToFrameworkElementConverter implements IValueConverter
{
  const StringToFrameworkElementConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    return (buckshot.namedElements.containsKey(value)) ? buckshot.namedElements[value] : null;
  }
}
