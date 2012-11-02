part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Conversion class for [String] <--> [BorderStyle].
 */
class StringToBorderStyleConverter implements IValueConverter
{
  const StringToBorderStyleConverter();

  dynamic convert(dynamic value, [dynamic parameter]){
    if (value is! String) return value;

    switch(value){
      case 'none':
        return BorderStyle.none;
      case 'dotted':
        return BorderStyle.dotted;
      case 'dashed':
        return BorderStyle.dashed;
      case 'solid':
        return BorderStyle.solid;
      case 'double':
        return BorderStyle.double;
      case 'groove':
        return BorderStyle.groove;
      case 'ridge':
        return BorderStyle.ridge;
      case 'inset':
        return BorderStyle.inset;
      case 'outset':
        return BorderStyle.outset;
      default:
        throw
        const BuckshotException('Unable to convert string to BorderStyle');
    }

  }
}
