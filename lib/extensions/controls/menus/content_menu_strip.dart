// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class ContentMenuStrip extends Control
{
  ContentMenuStrip()
  {
    Browser.appendClass(rawElement, "ContentMenuStrip");
  }

  ContentMenuStrip.register() : super.register();
  makeMe() => new ContentMenuStrip();
}
