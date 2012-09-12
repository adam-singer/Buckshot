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

  setView(new Main());
}