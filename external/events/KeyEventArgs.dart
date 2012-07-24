// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class KeyEventArgs extends EventArgs
{
  bool altKey = false;
  bool ctrlKey = false;
  bool shiftKey = false;
  
  bool isChar = false;
  
  final int keyCode;
  final int charCode;
  
  KeyEventArgs(this.keyCode, this.charCode);
}
