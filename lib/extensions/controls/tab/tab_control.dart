// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('tabcontrol.controls.buckshotui.org');

#import('dart:html');
#import('../../../../buckshot.dart');
//#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

#source('tab_item.dart');

class TabControl extends Control implements IFrameworkContainer
{
  FrameworkProperty currentContentProperty;
  FrameworkProperty tabItemsProperty;
  FrameworkProperty tabAlignmentProperty;

  final ObservableList<TabItem> children;

  TabControl() :
    children = new ObservableList<TabItem>()
  {
    Browser.appendClass(rawElement, "TabControl");

    _initTabContainerProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = getValue(tabItemsProperty);

  }

  TabControl.register() :
    children = new ObservableList<TabItem>();
  makeMe() => new TabControl();

  get content => getValue(tabItemsProperty);

  void _initTabContainerProperties(){
    currentContentProperty = new FrameworkProperty(this, 'currentContent');

    tabItemsProperty = new FrameworkProperty(this, 'tabItems',
        defaultValue: new ObservableList<TabItem>());

    //TODO: add a converter that overrides 'stretch' to 'left'
    tabAlignmentProperty = new FrameworkProperty(this, 'tabAlignment',
        defaultValue: HorizontalAlignment.left,
        converter: const StringToHorizontalAlignmentConverter());
  }


  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
     <stack>
        <collectionpresenter halign='{template tabAlignment}' datacontext='{template tabItems}'>
           <presentationpanel>
              <stack orientation='horizontal' />
           </presentationpanel>
           <itemstemplate>
              <border borderthickness='1,1,0,1' bordercolor='Black' padding='2'>
                 <textblock text='{data header}' />
              </border>
           </itemstemplate>
        </collectionpresenter>
        <border margin='-1,0,0,0' halign='stretch' borderthickness='1' bordercolor='Black' padding='5' content='{template currentContent}' />
     </stack>
  </template>
</controltemplate>
''';
  }
}

