// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dart_utils/shared.dart');
#import('package:DartNet-Event-Model/events.dart');
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

#import('apps/calculator/calculator.dart', prefix:'calc');
#import('apps/todo/todo.dart', prefix:'todo');

#source('viewmodels/demo_view_model.dart');
#source('models/demo_model.dart');
#source('views/main.dart');
#source('views/error_view.dart');

void main() {
  if (!reflectionEnabled){
    buckshot.registerElement(new TreeView.register() as BuckshotObject);
    buckshot.registerElement(new TreeNode.register() as BuckshotObject);
    buckshot.registerElement(new YouTube.register() as BuckshotObject);
    buckshot.registerElement(new Hulu.register() as BuckshotObject);
    buckshot.registerElement(new Vimeo.register() as BuckshotObject);
    buckshot.registerElement(new FunnyOrDie.register() as BuckshotObject);
    buckshot.registerElement(new ListBox.register() as BuckshotObject);
    buckshot.registerElement(new PlusOne.register() as BuckshotObject);
    buckshot.registerElement(new DockPanel.register() as BuckshotObject);
    buckshot.registerElement(new TabControl.register() as BuckshotObject);
    buckshot.registerElement(new TabItem.register() as BuckshotObject);
  }

  final view = new Main();
  
  setView(view).
    then((t){
      new Binding(buckshot.windowHeightProperty, t.parent.heightProperty);
      
      t.parent.background = 
          new SolidColorBrush(new Color.predefined(Colors.WhiteSmoke));
      
      final demo = queryString['demo'];
      
      if (demo != null){
        t.dataContext.setTemplate('#${demo}');
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