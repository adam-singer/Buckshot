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
  FrameworkProperty tabBackgroundProperty;

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
        <collectionpresenter halign='{template tabAlignment}' collection='{template tabItems}'>
           <presentationpanel>
              <stack orientation='horizontal' />
           </presentationpanel>
           <itemstemplate>
              <border cursor='Arrow' background='White' borderthickness='1,1,0,1' bordercolor='Black' padding='2'>
                 <actions>
                    <setproperty event='mouseEnter' property='background' value='Green' />
                    <setproperty event='mouseLeave' property='background' value='White' />
                 </actions>
                 <stack orientation='horizontal'>
                    <contentpresenter content='{data icon}' margin='0,2,0,0' />
                    <contentpresenter content='{data header}' />
                 </stack>
              </border>
           </itemstemplate>
        </collectionpresenter>
        <border halign='stretch' background='WhiteSmoke' borderthickness='1' 
             bordercolor='Black' padding='5' content='{template currentContent}'>
           <actions>
              <toggleproperty event='click' property='background' firstvalue='Green' secondvalue='WhiteSmoke' />
           </actions>
        </border>
     </stack>
  </template>
</controltemplate>
''';
  }
}

