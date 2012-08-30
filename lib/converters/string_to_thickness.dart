// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class StringToThicknessConverter implements IValueConverter{
  
  const StringToThicknessConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    List<String> svl = value.split(",");
    switch(svl.length){
      case 1:
        return new Thickness(parseInt(svl[0].trim()));
      case 2:
        return new Thickness.widthheight(parseInt(svl[0].trim()), parseInt(svl[1].trim()));
      case 4:
        return new Thickness.specified(parseInt(svl[0].trim()),parseInt(svl[1].trim()),parseInt(svl[2].trim()),parseInt(svl[3].trim()));
      default:
        throw const BuckshotException("Unable to parse Thickness property string.  Use format '0', '0,0', or '0,0,0,0'");
    }
  }
}
