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
* Defines properties of a column in a [Grid] element.
*
* ## Lucaxml Example Usage:
*     <grid>
*         <columndefinitions>
*             <columndefinition width="35"></columndefinition> <!-- A fixed column in pixels -->
*             <columndefinition width="auto"></columndefinition> <!-- Column auto sizes to widest element -->
*             <columndefinition width="*1"></columndefinition> <!-- A weighted portion of available space -->
*             <columndefinition width="*2"></columndefinition> <!-- A weighted portion of available space -->
*         </columndefinitions>
*     </grid> 
*
* ## See Also:
* * [RowDefinition]
* * [Grid]
* * [GridUnitType]
* * [GridLength]
*/
class ColumnDefinition extends GridLayoutDefinition{
  final FrameworkEvent _columnDefinitionChanged;
  
  /// Represents the [GridLength] width of the column.
  FrameworkProperty widthProperty;
  
  ColumnDefinition() : _columnDefinitionChanged = new FrameworkEvent()
  {
    _initColumnDefinitionProperties();
  }
  
  /// Constructs a column definition with a given [GridLength] value.
  ColumnDefinition.with(GridLength value) : _columnDefinitionChanged = new FrameworkEvent()
  {
    _initColumnDefinitionProperties();
    width = value;
  }
  
  /// Overridden [LucaObject] method.
  LucaObject makeMe() => new ColumnDefinition();
  
  void _initColumnDefinitionProperties(){
    widthProperty = new FrameworkProperty(this, "width", (GridLength v){
      if (v.value < minLength) v.value = minLength;
      if (v.value  > maxLength) v.value = maxLength;
      
      _value = v;
      _columnDefinitionChanged.invoke(this, new EventArgs());
    }, new GridLength());
    widthProperty.stringToValueConverter = const StringToGridLengthConverter();
  }
  
  /// Sets the [widthProperty] value.
  set width(GridLength v) => setValue(widthProperty, v);
  /// Gets the [widthProperty] value.
  GridLength get width() => getValue(widthProperty);
  
  String get type() => "ColumnDefinition";
}