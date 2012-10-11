// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/extensions/controls/media/youtube.dart');
#import('package:buckshot/extensions/controls/media/hulu.dart');
#import('package:buckshot/extensions/controls/media/vimeo.dart');
#import('package:buckshot/extensions/controls/media/funny_or_die.dart');
#import('package:buckshot/extensions/controls/list_box.dart');
#import('package:buckshot/extensions/controls/modal_dialog.dart');
#import('package:buckshot/extensions/controls/social/plus_one.dart');
#import('package:buckshot/extensions/controls/treeview/tree_view.dart');
#import('package:buckshot/extensions/controls/dock_panel.dart');
#import('package:buckshot/extensions/controls/popup.dart');
#import('package:buckshot/extensions/controls/tab_control/tab_control.dart');
#import('package:buckshot/extensions/controls/accordion/accordion.dart');
#import('package:buckshot/extensions/controls/menus/menu_lib.dart');

#import('apps/todo/todo.dart', prefix:'todo');
#import('viewmodels/calculator_viewmodel.dart');

#source('viewmodels/clock_viewmodel.dart');
#source('viewmodels/master_viewmodel.dart');
#source('models/demo_model.dart');
#source('views/main.dart');
#source('views/error_view.dart');
#source('views/calculator/calculator.dart');
#source('views/calculator/extended_calc.dart');
#source('views/calculator/standard_calc.dart');
#source('views/clock.dart');

void main() {
  if (!reflectionEnabled){
    buckshot.registerElement(new TreeView.register());
    buckshot.registerElement(new YouTube.register());
    buckshot.registerElement(new Hulu.register());
    buckshot.registerElement(new Vimeo.register());
    buckshot.registerElement(new FunnyOrDie.register());
    buckshot.registerElement(new ListBox.register());
    buckshot.registerElement(new PlusOne.register());
    buckshot.registerElement(new DockPanel.register());
    buckshot.registerElement(new TabControl.register());
    buckshot.registerElement(new Accordion.register());
    registerMenuControls();
  }

  Template
    .deserialize('web/views/templates/app_resources.xml')
    .chain((_) => setView(new Main()))
    .then((t){
         bind(buckshot.windowHeightProperty,
             (t.parent as Border).heightProperty);

         bind(buckshot.windowWidthProperty,
             (t.parent as Border).widthProperty);

        (t.parent as Border).background =
            new SolidColorBrush(getResource('theme_background_dark'));

        (t.parent as Border).verticalScrollEnabled = true;

        final demo = queryString['demo'];

        if (demo != null){
          t.dataContext.setTemplate('${demo}');
        }else{
          t.dataContext.setTemplate('welcome');
          t.dataContext.setQueryStringTo('welcome');
        }
    });


}


Map<String, String> get queryString() {
  var results = {};
  var qs;
  qs = window.location.search.isEmpty() ? ''
      : window.location.search.substring(1);
  var pairs = qs.split('&');

  for(final pair in pairs){
    var kv = pair.split('=');
    if (kv.length != 2) continue;
    results[kv[0]] = kv[1];
  }

  return results;
}