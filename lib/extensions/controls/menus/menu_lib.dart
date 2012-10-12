// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('menus.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');

#source('menu.dart');
#source('menu_item.dart');
#source('menu_strip.dart');
#source('menu_item_selected_event_args.dart');

/**
 * Registers [MenuStrip], [Menu], and [MenuItem] controls to the framework if
 * reflection is not enabled.
 */
void registerMenuControls(){
  if (reflectionEnabled) return;

  registerElement(new Menu.register());
  registerElement(new MenuItem.register());
  registerElement(new MenuStrip.register());
}

