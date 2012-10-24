part of core_buckshotui_org;

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
  FrameworkProperty<String> value;

  Color(){
    _initColorProperties();

    //meta data for binding system
    //this.stateBag[FrameworkResource.RESOURCE_PROPERTY] = valueProperty;
  }

  Color.register() : super.register();
  makeMe() => new Color();

  /// Allows construction of the color from 3 numeric values representing the R,G,B
  /// components of the color (0-255)
  Color.fromRGB(num r, num g, num b){
    _initColorProperties();
    value.value =
        "#${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}";
  }

  /// Allows construction of the color from a pre-defined color from the [Colors] enumeration.
  Color.predefined(Colors predefinedColor){
    _initColorProperties();
    value.value = predefinedColor.toString();
  }

  /// Allows construction of a color from an RGB [String].
  /// ## Usage:
  /// "#RRGGBB" with each color component representing a hexidecimal of 0-255.
  Color.hex(String hex){
    _initColorProperties();
    value.value = hex;
  }

  /// Gets the R (red) component of the RGB color.
  num get R => int.parse('0x${value.value.substring(1,3)}');
  /// Gets the G (green) component of the RGB color.
  num get G => int.parse('0x${value.value.substring(3,5)}');
  /// Gets the B (blue) compoonent of the RGB color.
  num get B => int.parse('0x${value.value.substring(5,7)}');

  void _initColorProperties(){
    value = new FrameworkProperty(this, "value",
    converter: const StringToColorStringConverter());
  }

  /// Returns the string representation of the color.
  String toColorString() => value.value;

  /**
   * This is a convenience method that gracefully handles accidental
   * assignments to properties that are actually of type Brush.
   */
  void renderBrush(Element element){
    element.style.background = "${value.value}";
  }
}