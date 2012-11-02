part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/** 
* Attempts to convert a given [String] to a [GridLength] object 
*/
class StringToGridLengthConverter implements IValueConverter
{
  const StringToGridLengthConverter();
  
  dynamic convert(dynamic value, [dynamic parameter]){
    if (!(value is String)) return value;
   
    // auto length
    if (value == "auto"){
      return new GridLength.auto();
    }
    
    // star length
    if (value.contains('*')){
      String stripped = value.replaceAll('*', '');
      
      //if only a star, then assume default value 1
      if (stripped == '') return new GridLength.star(1);
      
      //only a numeric should be left
      try{
        num val = double.parse(stripped);
        return new GridLength.star(val);
      }on FormatException catch (e){
        throw const BuckshotException("Unable to parse gridlength value.");
      }
    }
   
    // should be pixel
    try{
      num val = int.parse(value);
      return new GridLength.pixel(val);
    }on FormatException catch (e){
      throw const BuckshotException("Unable to parse gridlength value.");
    }
  }
}
