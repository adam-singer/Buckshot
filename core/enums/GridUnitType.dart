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
        throw const FrameworkException("Invalid GridUntiType value.");
    }
  }
}