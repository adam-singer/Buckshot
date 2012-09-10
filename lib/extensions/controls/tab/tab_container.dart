// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('tabcontainer.controls.buckshotui.org');

#import('dart:html');
#import('../../../../buckshot.dart');
//#import('package:DartNet-Event-Model/events.dart');
//#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

#source('tab_item.dart');

class TabContainer extends Control implements IFrameworkContainer
{
  FrameworkProperty currentContentProperty;
  FrameworkProperty tabItemsProperty;
  
  final ObservableList<TabItem> children;
  
  TabContainer() :
    children = new ObservableList<TabItem>()
  {
    Browser.appendClass(rawElement, "TabContainer");
        
    _initTabContainerProperties();
    
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = getValue(tabItemsProperty);

    
    final presenter = 
        Template.findByName('__tc_collection_presenter__', template);
    
    loaded + (_,__) {
      print('>>> ${getValue(tabItemsProperty)}');

      presenter.dataContext = getValue(tabItemsProperty);
      (presenter as CollectionPresenter).invalidate();
      presenter.presentationPanel.children.forEach((child){
        child.updateDataContext();
      });
    };
  }
  
  TabContainer.register() :
    children = new ObservableList<TabItem>();
  
  makeMe() => new TabContainer();

  get content => getValue(tabItemsProperty);
  
  void _initTabContainerProperties(){
    currentContentProperty = new FrameworkProperty(this, 'currentContent');
    
    tabItemsProperty = new FrameworkProperty(this, 'tabItems',
        defaultValue: new ObservableList<TabItem>());
  }
  
  
  String get defaultControlTemplate {
    return
        '''
<controltemplate controlType='${this.templateName}'>
  <template>
    <stack halign='stretch'>
       <stack orientation='horizontal' />
      <collectionpresenter name='__tc_collection_presenter__' datacontext='{template tabItems}'>
        <presentationpanel>
           <stack orientation='horizontal' />
        </presentationpanel>
        <itemstemplate>
          <border borderthickness='1' bordercolor='Black' padding='2'>
            <textblock text='{data header}' />
          </border>
        </itemstemplate>
      </collectionpresenter>
       <border halign='stretch' borderthickness='1' bordercolor='Black' padding='5' content='{template currentContent}' />
    </stack>
  </template>
</controltemplate>
        ''';
  }
}

                                                                                                                                                                                                                       