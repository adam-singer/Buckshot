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
  final FrameworkEvent _columnDefinitionChanged;

  /// Represents the [GridLength] width of the column.
  FrameworkProperty widthProperty;

  ColumnDefinition() : _columnDefinitionChanged = new FrameworkEvent()
  {
    _initColumnDefinitionProperties();
  }

  ColumnDefinition.register() : super.register(),
    _columnDefinitionChanged = new FrameworkEvent();
  makeMe() => new ColumnDefinition();
  
  /// Constructs a column definition with a given [GridLength] value.
  ColumnDefinition.with(GridLength value) : _columnDefinitionChanged = new FrameworkEvent()
  {
    _initColumnDefinitionProperties();
    width = value;
  }

  void _initColumnDefinitionProperties(){
    widthProperty = new FrameworkProperty(this, "width", (GridLength v){
      if (v.value < minLength) v.value = minLength;
      if (v.value  > maxLength) v.value = maxLength;

      _value = v;
      _columnDefinitionChanged.invoke(this, new EventArgs());
    }, new GridLength(), converter:const StringToGridLengthConverter());
  }

  /// Sets the [widthProperty] value.
  set width(GridLength v) => setValue(widthProperty, v);
  /// Gets the [widthProperty] value.
  GridLength get width => getValue(widthProperty);
}