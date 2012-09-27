// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/** Represents an item in a [Menu] control */
class MenuItem extends Control
{
  MenuItem()
  {
    Browser.appendClass(rawElement, "MenuItem");
  }

  MenuItem.register() : super.register();
  makeMe() => new MenuItem();
}
