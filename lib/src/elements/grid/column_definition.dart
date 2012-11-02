part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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
  final FrameworkEvent _columnDefinitionChanged = new FrameworkEvent();

  /// Represents the [GridLength] width of the column.
  FrameworkProperty<GridLength> width;

  ColumnDefinition()
  {
    _initColumnDefinitionProperties();
  }

  ColumnDefinition.register() : super.register();
  makeMe() => new ColumnDefinition();

  /// Constructs a column definition with a given [GridLength] value.
  ColumnDefinition.with(GridLength value)
  {
    _initColumnDefinitionProperties();
    width.value = value;
  }

  void _initColumnDefinitionProperties(){
    width = new FrameworkProperty(this, "width",
    propertyChangedCallback: (GridLength v){
      if (v.length.value < minLength) v.length.value = minLength;
      if (v.length.value > maxLength) v.length.value = maxLength;

      _gridLength = v;
      _columnDefinitionChanged.invoke(this, new EventArgs());
    },
    defaultValue:new GridLength(),
    converter:const StringToGridLengthConverter());
  }
}