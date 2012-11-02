part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class StringToThicknessConverter implements IValueConverter{

  const StringToThicknessConverter();

  dynamic convert(dynamic value, [dynamic parameter]){
    if (value is! String) return value;

    List<String> svl = value.split(",");
    switch(svl.length){
      case 1:
        return new Thickness(int.parse(svl[0].trim()));
      case 2:
        return new Thickness.widthheight(int.parse(svl[0].trim()), int.parse(svl[1].trim()));
      case 4:
        return new Thickness.specified(int.parse(svl[0].trim()),int.parse(svl[1].trim()),int.parse(svl[2].trim()),int.parse(svl[3].trim()));
      default:
        throw const BuckshotException("Unable to parse Thickness property string.  Use format '0', '0,0', or '0,0,0,0'");
    }
  }
}
