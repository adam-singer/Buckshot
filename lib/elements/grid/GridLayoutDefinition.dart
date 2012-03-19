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
* Base class for Grid row/column definition types.
* 
* ## See Also
* * [ColumnDefinition]
* * [RowDefinition]
*/
class GridLayoutDefinition extends BuckshotObject{
  
  int _adjustedLengthInternal = 0;
  Node _htmlNode;
  
  GridLength _value;
  int _adjustedOffset = 0;
  
  set _adjustedLength(int value){
    if (value < minLength) value = minLength;
    if (value > maxLength) value = maxLength;
    
    _adjustedLengthInternal = value;
  }
  int get _adjustedLength() => _adjustedLengthInternal;
    
  int maxLength = 32767; //why not? ;)
  int minLength = 0;
  
  String get _type() => "GridLayoutDefinition";
}