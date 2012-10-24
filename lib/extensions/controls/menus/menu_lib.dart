// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library menus_controls_buckshot;

import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:dartnet_event_model/events.dart';
import 'package:buckshot/web/web.dart';

part 'menu.dart';
part 'menu_item.dart';
part 'menu_strip.dart';
part 'menu_item_selected_event_args.dart';

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

