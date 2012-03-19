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
* Enumrates supported binding modes in a [Binding]. */
class BindingMode
{
  final int _val;
  const BindingMode(this._val);
  
  /// Indicates a [Binding] where changes only flow in one direction.
  static final OneWay = const BindingMode(1);
  
  /// Indicates a [Binding] where changes flow in both directions.
  static final TwoWay = const BindingMode(2);
  
  /// Indicates a [Binding] that fires once and then unregisters automatically.
  static final OneTime = const BindingMode(3);
  
  String toString() {
    switch (_val){
    case 1:
      return "OneWay";
    case 2:
      return "TwoWay";
    case 3:
      return "OneTime";
    default:
      return "";
    }
  }
}
