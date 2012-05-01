//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* Represents a color resource.
*
* ## Lucaxml Example Usage
*     <color value='#33aa7c'></color>
*     <color value='Orange'></color> <!-- color name is case sensitive -->
*/
class Color extends FrameworkResource
{ 
  /// Represents the value of the color.
  FrameworkProperty valueProperty;
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new Color();
  
  Color(){
    _initColorProperties();
    
    //meta data for binding system
    this._stateBag[FrameworkResource.RESOURCE_PROPERTY] = valueProperty;
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
  num get R() => Math.parseInt('0x${value.substring(1,3)}');
  /// Gets the G (green) component of the RGB color.
  num get G() => Math.parseInt('0x${value.substring(3,5)}');
  /// Gets the B (blue) compoonent of the RGB color.
  num get B() => Math.parseInt('0x${value.substring(5,7)}');
  
  /// Gets the [valueProperty] value.
  String get value() => getValue(valueProperty);
  /// Sets the [valueProperty] value.
  set value(String c) => setValue(valueProperty, c);
  
  void _initColorProperties(){
    valueProperty = new FrameworkProperty(this, "value", (String c){
      if (!c.startsWith("#") || c.length != 7){
        db(c);
        throw const BuckshotException("Invalid color format.  Use '#rrggbb'");
      }
    }, Colors.White.toString());
  }
  
  /// Returns the string representation of the color.
  String toString() => value;
  
  String get type() => "Color";
}