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
* Enumerates vertical alignment values. */
class VerticalAlignment{
  const VerticalAlignment(this._str);
  final String _str;
  static final center = const VerticalAlignment("center");
  static final stretch = const VerticalAlignment("stretch");
  static final top = const VerticalAlignment("top");
  static final bottom = const VerticalAlignment("bottom");
  
  /// Deperecated.  Use .toString()
  String asString() => _str;
  
  String toString() => _str;
}