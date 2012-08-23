// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a color resource.
*
* ## Template Example Usage
*     <color value='#33aa7c'></color>
*     <color value='Orange'></color> <!-- color name is case sensitive -->
*/
class Color extends FrameworkResource
{
  /// Represents the value of the color.
  FrameworkProperty valueProperty;

  Color(){
    _initColorProperties();

    //meta data for binding system
    this.stateBag[FrameworkResource.RESOURCE_PROPERTY] = valueProperty;
  }

  /// Allows construction of the color from 3 numeric values representing the R,G,B
  /// components of the color (0-255)
  Color.fromRGB(num r, num g, num b){
    _initColorProperties();
    value = "#${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}";
  }

  /// Allows construction of the color from a pre-defined color from the [Colors] enumeration.
  Color.predefined(Colors predefinedColor){
    _initColorProperties();
    value = predefinedColor.toString();
  }

  /// Allows construction of a color from an RGB [String].
  /// ## Usage:
  /// "#RRGGBB" with each color component representing a hexidecimal of 0-255.
  Color.hex(String hex){
    _initColorProperties();
    value = hex;
  }

  /// Gets the R (red) component of the RGB color.
  num get R() => parseInt('0x${value.substring(1,3)}');
  /// Gets the G (green) component of the RGB color.
  num get G() => parseInt('0x${value.substring(3,5)}');
  /// Gets the B (blue) compoonent of the RGB color.
  num get B() => parseInt('0x${value.substring(5,7)}');

  /// Gets the [valueProperty] value.
  String get value() => getValue(valueProperty);
  /// Sets the [valueProperty] value.
  set value(String c) => setValue(valueProperty, c);

  void _initColorProperties(){
    valueProperty = new FrameworkProperty(this, "value", (String c){
      if (!c.startsWith("#") || c.length != 7){
        throw const BuckshotException("Invalid color format.  Use '#rrggbb'");
      }
    }, Colors.White.toString());
  }

  /// Returns the string representation of the color.
  String toString() => value;
}