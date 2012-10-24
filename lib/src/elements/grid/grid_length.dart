part of core_buckshotui_org;

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
  FrameworkProperty<GridUnitType> gridUnitType;
  /// Represents the value of the GridLength.
  /// The context of the value changes based on the [GridUnitType] of
  /// the [gridUnitTypeProperty].
  FrameworkProperty<num> length;

  //default length is auto
  GridLength(){
    _initGridUnitTypeProperties();
  }

  makeMe() => null;

  /// Constructs a GridLength as a [GridUnitType] star type.
  GridLength.star(num v){
    _initGridUnitTypeProperties();
    gridUnitType.value = GridUnitType.star;
    length.value = v;
  }

  /// Constructs a GridLength as a [GridUnitType] auto type.
  GridLength.auto(){
    _initGridUnitTypeProperties();
  }

  /// Constructs a GridLength as a [GridUnitType] pixel type.
  GridLength.pixel(num v){
    _initGridUnitTypeProperties();
    gridUnitType.value = GridUnitType.pixel;
    length.value = v;
  }

  void _initGridUnitTypeProperties(){
    gridUnitType = new FrameworkProperty(this,
        "gridUnitType",
        defaultValue:GridUnitType.auto);

    length = new FrameworkProperty(this, "value", defaultValue: -1);
  }
}
