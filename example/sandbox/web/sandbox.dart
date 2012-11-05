// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
library sandbox;

import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:dartnet_event_model/events.dart';
import 'package:buckshot/extensions/controls/media/youtube.dart';
import 'package:buckshot/extensions/controls/media/hulu.dart';
import 'package:buckshot/extensions/controls/media/vimeo.dart';
import 'package:buckshot/extensions/controls/media/funny_or_die.dart';
import 'package:buckshot/extensions/controls/list_box.dart';
import 'package:buckshot/extensions/controls/modal_dialog.dart';
import 'package:buckshot/extensions/controls/social/plus_one.dart';
import 'package:buckshot/extensions/controls/treeview/tree_view.dart';
import 'package:buckshot/extensions/controls/dock_panel.dart';
import 'package:buckshot/extensions/controls/popup.dart';
import 'package:buckshot/extensions/controls/tab_control/tab_control.dart';
import 'package:buckshot/extensions/controls/accordion/accordion.dart';
import 'package:buckshot/extensions/controls/menus/menu_lib.dart';

import 'apps/todo/todo.dart' as todo;
import 'viewmodels/calculator_viewmodel.dart';

part 'viewmodels/clock_viewmodel.dart';
part 'viewmodels/master_viewmodel.dart';
part 'models/demo_model.dart';
part 'views/main.dart';
part 'views/error_view.dart';
part 'views/calculator/calculator.dart';
part 'views/calculator/extended_calc.dart';
part 'views/calculator/standard_calc.dart';
part 'views/clock.dart';

void main() {
  if (!reflectionEnabled){
    registerElement(new TreeView.register());
    registerElement(new YouTube.register());
    registerElement(new Hulu.register());
    registerElement(new Vimeo.register());
    registerElement(new FunnyOrDie.register());
    registerElement(new ListBox.register());
    registerElement(new PlusOne.register());
    registerElement(new DockPanel.register());
    registerElement(new TabControl.register());
    registerElement(new Accordion.register());
    registerMenuControls();
  }


  setView(new Main())
    .then((t){
        bindToWindowDimensions(t.parent);

        (t.parent as Border).background.value = getResource('theme_dark_brush');

        (t.parent as Border).verticalScrollEnabled.value = true;

        final demo = queryString['demo'];

        if (demo != null){
          t.dataContext.value.setTemplate('${demo}');
        }else{
          t.dataContext.value.setTemplate('welcome');
          t.dataContext.value.setQueryStringTo('welcome');
        }
    });


}


Map<String, String> get queryString {
  var results = {};
  var qs;
  qs = window.location.search.isEmpty ? ''
      : window.location.search.substring(1);
  var pairs = qs.split('&');

  for(final pair in pairs){
    var kv = pair.split('=');
    if (kv.length != 2) continue;
    results[kv[0]] = kv[1];
  }

  return results;
}