// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
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
    gridUnitTypeProperty = new FrameworkProperty(this,
        "gridUnitType",
        defaultValue:GridUnitType.auto);

    valueProperty = new FrameworkProperty(this, "value", defaultValue:-1);
  }
}
