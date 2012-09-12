// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/** Provides a conversion between [String] and [InputTypes]. */
class StringToInputTypesConverter implements IValueConverter{
  const StringToInputTypesConverter();
    
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (value is! String) return value;
    
    switch(value){
    case "password":
      return InputTypes.password;
    case "email":
      return InputTypes.email;
    case "date":
      return InputTypes.date;
    case "datetime":
      return InputTypes.datetime;
    case "month":
      return InputTypes.month;
    case "search":
      return InputTypes.search;
    case "telephone":
      return InputTypes.telephone;
    case "text":
      return InputTypes.text;
    case "time":
      return InputTypes.time;
    case "url":
      return InputTypes.url;
    case "week":
      return InputTypes.week;
    default:
      throw const BuckshotException("Invalid InputTypes value.");
    }
  }
}
