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
* Defines the measurement of a [Grid] row or column.
* 
* ## See Also
* * [ColumnDefinition]
* * [RowDefinition]
*/
class GridLength extends FrameworkObject{
 
  /// Represents the [GridUnitType] of the GridLength.
  FrameworkProperty gridUnitTypeProperty;
  /// Represents the value of the GridLength.
  /// The context of the value changes based on the [GridUnitType] of
  /// the [gridUnitTypeProperty].
  FrameworkProperty valueProperty;
  
  //default length is auto
  GridLength(){
    _initGridUnitTypeProperties();
  }
  
  /// Constructs a GridLength as a [GridUnitType] star type.
  GridLength.star(num v){
    _initGridUnitTypeProperties();
    gridUnitType = GridUnitType.star;
    value = v;
  }
  
  /// Constructs a GridLength as a [GridUnitType] auto type.
  GridLength.auto(){
    _initGridUnitTypeProperties();
  }
  
  /// Constructs a GridLength as a [GridUnitType] pixel type.
  GridLength.pixel(num v){
    _initGridUnitTypeProperties();
    gridUnitType = GridUnitType.pixel;
    value = v;
  }
  
  /// Gets the [gridUnitTypeProperty] value.
  GridUnitType get gridUnitType() => getValue(gridUnitTypeProperty);
  /// Sets the [gridUnitTypeProperty] value.
  set gridUnitType(GridUnitType v) => setValue(gridUnitTypeProperty, v);
  
  /// Gets the [valueProperty] value.
  num get value() => getValue(valueProperty);
  /// Sets the [valueProperty] value.
  set value(num v) => setValue(valueProperty, v);
  
  void _initGridUnitTypeProperties(){
    gridUnitTypeProperty = new FrameworkProperty(this, "gridUnitType", (GridUnitType v){
      
    }, GridUnitType.auto);
    
    valueProperty = new FrameworkProperty(this, "value", (num v){
      
    }, -1);
  }
  
  String get type() => "GridLength";
}
