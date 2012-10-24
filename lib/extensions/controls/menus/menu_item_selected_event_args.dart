part of menus_controls_buckshot;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/** [EventArgs] class for events that fire when a [MenuItem] is selected. */
class MenuItemSelectedEventArgs extends EventArgs
{
  /**
   * The [MenuItem] that was selected.  In cases where only the menu header
   * was selected (with no menu items available), this value will be null,
   * indicating that the menu itself was selected.  You should then look
   * to the sender value of the event to get the instance of the menu
   * selected.
   */
  final MenuItem selectedMenuItem;

  MenuItemSelectedEventArgs(this.selectedMenuItem);
}
