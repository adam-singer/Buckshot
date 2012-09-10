// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#import('dart:html');
#import('../../buckshot.dart');
#import('package:dart_utils/shared.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../lib/extensions/controls/media/youtube.dart');
#import('../../lib/extensions/controls/media/hulu.dart');
#import('../../lib/extensions/controls/media/vimeo.dart');
#import('../../lib/extensions/controls/media/funny_or_die.dart');
#import('../../lib/extensions/controls/list_box.dart');
#import('../../lib/extensions/controls/modal_dialog.dart');
#import('../../lib/extensions/controls/social/plus_one.dart');
#import('../../lib/extensions/controls/treeview/tree_view.dart');
#import('../../lib/extensions/controls/dock_panel.dart');
#import('../../lib/extensions/controls/popup.dart');
#import('../../lib/extensions/controls/tab/tab_container.dart');

#import('apps/calculator/calculator.dart', prefix:'calc');
#import('apps/todo/todo.dart', prefix:'todo');

#source('viewmodels/demo_view_model.dart');
#source('models/demo_model.dart');
#source('views/main.dart');
#source('views/error_view.dart');

void main() {
  if (!reflectionEnabled){
    buckshot.registerElement(new TreeView.register());
    buckshot.registerElement(new TreeNode.register());
    buckshot.registerElement(new YouTube.register());
    buckshot.registerElement(new Hulu.register());
    buckshot.registerElement(new Vimeo.register());
    buckshot.registerElement(new FunnyOrDie.register());
    buckshot.registerElement(new ListBox.register());
    buckshot.registerElement(new PlusOne.register());
    buckshot.registerElement(new DockPanel.register());
    buckshot.registerElement(new TabContainer.register());
    buckshot.registerElement(new TabItem.register());
  }
  
  setView(new Main());
}