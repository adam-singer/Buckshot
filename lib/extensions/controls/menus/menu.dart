// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Represents a floating vertical list of selectable items.
 */
class Menu extends Control
{
  FrameworkProperty titleProperty;
  FrameworkProperty showTitleProperty;
  FrameworkProperty menuItemsProperty;

  Menu()
  {
    Browser.appendClass(rawElement, "Menu");

    _initMenuProperties();
  }

  Menu.register() : super.register();
  makeMe() => new Menu();

  void _initMenuProperties(){
    titleProperty = new FrameworkProperty(this, 'title', defaultValue: '');

    showTitleProperty = new FrameworkProperty(this, 'showtitle',
        defaultValue: false,
        converter: const StringToBooleanConverter());

    menuItemsProperty = new FrameworkProperty(this, 'menuItems',
        defaultValue: new ObservableList<MenuItem>());
  }
}
