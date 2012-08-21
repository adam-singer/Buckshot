// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
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

  void _initRowDefinitionProperties(){
    heightProperty = new FrameworkProperty(this, "height", (GridLength v){
      if (v.value < minLength) v.value = minLength;
      if (v.value  > maxLength) v.value = maxLength;

      _value = v;
      _rowDefinitionChanged.invoke(this, new EventArgs());
    }, new GridLength(), converter:const StringToGridLengthConverter());
  }

  /// Sets the [heightProperty] value.
  set height(GridLength v) => setValue(heightProperty, v);
  /// Gets the [heightProperty] value.
  GridLength get height() => getValue(heightProperty);

  String get type() => "RowDefinition";
}
