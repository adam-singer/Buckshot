// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('tabcontrol.controls.buckshotui.org');

#import('dart:html');
#import('../../../../buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

#source('tab_item.dart');
#source('tab_selected_event_args.dart');

class TabControl extends Control implements IFrameworkContainer
{
  FrameworkProperty currentContentProperty;
  FrameworkProperty tabItemsProperty;
  FrameworkProperty tabAlignmentProperty;
  FrameworkProperty tabBackgroundProperty;

  final FrameworkEvent<TabSelectedEventArgs> tabSelected;
  
  TabControl() :
    tabSelected = new FrameworkEvent<TabSelectedEventArgs>()
  {
    Browser.appendClass(rawElement, "TabControl");

    _initTabContainerProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = getValue(tabItemsProperty);

    loaded + _initControl;
    
    tabSelected + (_, args){
      print('selected ${getValue(args.tab.headerProperty)}');
    };
  }

  TabControl.register() :
    tabSelected = new FrameworkEvent<TabSelectedEventArgs>();
  makeMe() => new TabControl();

  get content => getValue(tabItemsProperty);

  
  void _initControl(sender, args){
    if (tabItems.isEmpty()) return;

    // this is the collection of the visual elements representing each
    // tab
    final pc = (Template.findByName('__tc_presenter__', template)
                           as CollectionPresenter)
                        .presentationPanel
                        .children;
    
    int i = 0;
    pc.forEach((e){
      final ti = tabItems[i++];
      e.click + (_, __){
        tabSelected.invokeAsync(this, new TabSelectedEventArgs(ti));
      };
    });
    assert(pc != null);
    
    
  }
  
  void _initTabContainerProperties(){
    currentContentProperty = new FrameworkProperty(this, 'currentContent');

    tabItemsProperty = new FrameworkProperty(this, 'tabItems',
        defaultValue: new ObservableList<TabItem>());

    tabAlignmentProperty = new FrameworkProperty(this, 'tabAlignment',
        defaultValue: HorizontalAlignment.left,
        converter: const StringToHorizontalAlignmentConverter());
    
  }

  ObservableList<TabItem> get tabItems => getValue(tabItemsProperty);
  

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
     <stack>
        <collectionpresenter name='__tc_presenter__' halign='{template tabAlignment}' collection='{template tabItems}'>
           <presentationpanel>
              <stack orientation='horizontal' />
           </presentationpanel>
           <itemstemplate>
              <border cornerradius='7,7,0,0' cursor='Arrow' background='White' borderthickness='1,1,0,1' bordercolor='Black' padding='2'>
                 <stack orientation='horizontal'>
                    <contentpresenter content='{data icon}' margin='0,2,0,0' />
                    <contentpresenter content='{data header}' margin='0,3,0,0' />
                    <border width='25'>
                      <button visibility='{data closeButtonVisibility}' content='x' />
                    </border>
                 </stack>
              </border>
           </itemstemplate>
        </collectionpresenter>
        <border halign='stretch' background='WhiteSmoke' borderthickness='1' 
             bordercolor='Black' padding='5' content='{template currentContent}'>
        </border>
     </stack>
  </template>
</controltemplate>
''';
  }
}

