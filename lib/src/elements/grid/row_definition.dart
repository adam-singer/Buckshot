part of core_buckshotui_org;

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
  final FrameworkEvent _rowDefinitionChanged = new FrameworkEvent();

  /// Represents the [GridLength] height of the row.
  FrameworkProperty<GridLength> height;

  RowDefinition()
  {
    _initRowDefinitionProperties();
  }

  RowDefinition.register() : super.register();
  makeMe() => new RowDefinition();

  /// Constructs a row definition with a given [GridLength] value.
  RowDefinition.with(GridLength value)
  {
    _initRowDefinitionProperties();
    height.value = value;
  }

  void _initRowDefinitionProperties(){
    height = new FrameworkProperty(this, "height",
      propertyChangedCallback: (GridLength v){
        if (v.length.value < minLength) v.length.value = minLength;
        if (v.length.value  > maxLength) v.length.value = maxLength;

        _gridLength = v;
        _rowDefinitionChanged.invoke(this, new EventArgs());
      },
      defaultValue: new GridLength(),
      converter:const StringToGridLengthConverter());
  }
}
