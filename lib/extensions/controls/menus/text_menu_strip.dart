// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class TextMenuStrip extends Control
{
  TextMenuStrip()
  {
    Browser.appendClass(rawElement, "TextMenuStrip");
  }

  TextMenuStrip.register() : super.register();
  makeMe() => new TextMenuStrip();
}
