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
* Enumerates available [FrameworkElement] cursor types. */
class Cursors
{
  const Cursors(this._str);
  final String _str;
  static final Auto = const Cursors("auto");
  static final Crosshair = const Cursors("crosshair");
  static final Arrow = const Cursors("default");
  static final Default = const Cursors("default");
  static final ResizeE = const Cursors("e-resize");
  static final Help = const Cursors("help");
  static final Move = const Cursors("move");
  static final ResizeN = const Cursors("n-resize");
  static final ResizeNE = const Cursors("ne-resize");
  static final ResizeNW = const Cursors("nw-resize");
  static final Pointer = const Cursors("pointer");
  static final Progress = const Cursors("progress");
  static final ResizeS = const Cursors("s-resize");
  static final ResizeSE = const Cursors("se-resize");
  static final ResizeSW = const Cursors("sw-resize");
  static final Text = const Cursors("text");
  static final Wait = const Cursors("wait");
  static final Inherit = const Cursors("inherit");

  String toString() => _str;
}

/**
* Converts a [String] value to [Cursors] enumerable.
*/
class StringToCursorConverter implements IValueConverter {

  const StringToCursorConverter();

  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    switch(value){
      case "Auto":
        return Cursors.Auto;
      case "Crosshair":
        return Cursors.Crosshair;
      case "Default":
      case "Arrow":
        return Cursors.Default;
      case "ResizeE":
        return Cursors.ResizeE;
      case "Help":
        return Cursors.Help;
      case "Move":
        return Cursors.Move;
      case "ResizeN":
        return Cursors.ResizeN;
      case "ResizeNE":
        return Cursors.ResizeNE;
      case "ResizeNW":
        return Cursors.ResizeNW;
      case "Pointer":
        return Cursors.Pointer;
      case "Progress":
        return Cursors.Progress;
      case "ResizeS":
        return Cursors.ResizeS;
      case "ResizeSE":
        return Cursors.ResizeSE;
      case "ResizeSW":
        return Cursors.ResizeSW;
      case "Text":
        return Cursors.Text;
      case "Wait":
        return Cursors.Wait;
      case "Inherit":
        return Cursors.Inherit;
      default:
        throw const BuckshotException("Cursor property value not recognized.");

    }
  }
}
