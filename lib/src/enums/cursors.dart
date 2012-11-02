part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Enumerates available [FrameworkElement] cursor types. */
class Cursors
{
  const Cursors(this._str);
  final String _str;
  static const Auto = const Cursors("auto");
  static const Crosshair = const Cursors("crosshair");
  static const Arrow = const Cursors("default");
  static const Default = const Cursors("default");
  static const ResizeE = const Cursors("e-resize");
  static const Help = const Cursors("help");
  static const Move = const Cursors("move");
  static const ResizeN = const Cursors("n-resize");
  static const ResizeNE = const Cursors("ne-resize");
  static const ResizeNW = const Cursors("nw-resize");
  static const Pointer = const Cursors("pointer");
  static const Progress = const Cursors("progress");
  static const ResizeS = const Cursors("s-resize");
  static const ResizeSE = const Cursors("se-resize");
  static const ResizeSW = const Cursors("sw-resize");
  static const Text = const Cursors("text");
  static const Wait = const Cursors("wait");
  static const Inherit = const Cursors("inherit");

  String toString() => _str;
}

/**
* Converts a [String] value to [Cursors] enumerable.
*/
class StringToCursorConverter implements IValueConverter {

  const StringToCursorConverter();

  dynamic convert(dynamic value, [dynamic parameter]){
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
