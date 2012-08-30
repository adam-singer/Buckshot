// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#import('dart:html');
#import('../../buckshot.dart');
#import('../../external/shared/shared.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('../../extensions/controls/media/YouTube.dart');
#import('../../extensions/controls/media/Hulu.dart');
#import('../../extensions/controls/media/Vimeo.dart');
#import('../../extensions/controls/media/FunnyOrDie.dart');
#import('../../extensions/controls/ListBox.dart');
#import('../../extensions/controls/ModalDialog.dart');
#import('../../extensions/controls/social/PlusOne.dart');
#import('../../extensions/controls/TreeView/TreeView.dart');
#import('../../extensions/controls/DockPanel.dart');

#import('apps/calculator/calculator.dart', prefix:'calc');
#import('apps/todo/todo.dart', prefix:'todo');

#source('viewmodels/demo_view_model.dart');
#source('models/demo_model.dart');
#source('views/main.dart');
#source('views/error.dart');

void main() {
  setView(new Main());
}