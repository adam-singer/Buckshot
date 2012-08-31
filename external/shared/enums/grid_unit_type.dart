// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates [Grid] column/row [GridLength] measurements.
*
* * star = a weighted value of available space, relative to other star'd peers. 
* * pixel = a fixed value 
* * auto = auto sizes to the largest element in the column/row 
*/
class GridUnitType{
  const GridUnitType(this._val);
  final int _val;
 
  static final star = const GridUnitType(1);
  static final pixel = const GridUnitType(2);
  static final auto = const GridUnitType(3);  

  String toString() {
    switch(_val){
      case 1:
        return "star";
      case 2:
        return "pixel";
      case 3:
        return "auto";
      default:
        throw const BuckshotException("Invalid GridUntiType value.");
    }
  }
}