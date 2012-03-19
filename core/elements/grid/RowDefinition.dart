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
* Defines properties of a row in a [Grid] element.
*
* ## Lucaxml Example Usage:
*     <grid>
*         <rowdefinitions>
*             <rowdefinition height="35"></rowdefinition> <!-- A fixed row in pixels -->
*             <rowdefinition height="auto"></rowdefinition> <!-- Row auto sizes to widest element -->
*             <rowdefinition height="*1"></rowdefinition> <!-- A weighted portion of available space -->
*             <rowdefinition height="*2"></rowdefinition> <!-- A weighted portion of available space -->
*         </rowdefinitions>
*     </grid> 
*
* ## See Also:
* * [ColumnDefinition]
* * [Grid]
* * [GridUnitType]
* * [GridLength]
*/
class RowDefinition extends GridLayoutDefinition{
  final FrameworkEvent _rowDefinitionChanged;
  
  /// Represents the [GridLength] height of the row.
  FrameworkProperty heightProperty;
  
  RowDefinition() : _rowDefinitionChanged = new FrameworkEvent()
  {
    _initRowDefinitionProperties();
  }
  
  /// Constructs a row definition with a given [GridLength] value.
  RowDefinition.with(GridLength value) : _rowDefinitionChanged = new FrameworkEvent()
  {
    _initRowDefinitionProperties();
    height = value;
  }
  
  /// Overridden [LucaObject] method.
  LucaObject makeMe() => new RowDefinition();
  
  void _initRowDefinitionProperties(){
    heightProperty = new FrameworkProperty(this, "height", (GridLength v){
      if (v.value < minLength) v.value = minLength;
      if (v.value  > maxLength) v.value = maxLength;
      
      _value = v;
      _rowDefinitionChanged.invoke(this, new EventArgs());
    }, new GridLength());
    heightProperty.stringToValueConverter = const StringToGridLengthConverter();
  }
  
  /// Sets the [heightProperty] value.
  set height(GridLength v) => setValue(heightProperty, v);
  /// Gets the [heightProperty] value.
  GridLength get height() => getValue(heightProperty);
  
  String get type() => "RowDefinition";
}
