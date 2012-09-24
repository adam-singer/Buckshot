// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('tabcontrol.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
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
  FrameworkProperty tabSelectedBrushProperty;
  FrameworkProperty backgroundProperty;

  final FrameworkEvent<TabSelectedEventArgs> tabSelected;
  final FrameworkEvent<TabSelectedEventArgs> tabClosing;
  
  TabItem currentTab;
  Brush _tabBackground;
  
  TabControl() :
    tabSelected = new FrameworkEvent<TabSelectedEventArgs>(),
    tabClosing = new FrameworkEvent<TabSelectedEventArgs>()
  {
    Browser.appendClass(rawElement, "TabControl");

    _initTabContainerProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = getValue(tabItemsProperty);

    loaded + _initControl;
  }

  TabControl.register() : super.register(),
    tabSelected = new FrameworkEvent<TabSelectedEventArgs>(),
    tabClosing = new FrameworkEvent<TabSelectedEventArgs>();
  makeMe() => new TabControl();

  get content => getValue(tabItemsProperty);
  
  void switchToTab(TabItem tab){
    if (currentTab == tab) return;

    if (currentTab != null){     
      final b = currentTab._visualTemplate as Border;
      
      //remove active markings on this tab.
      setValue(currentTab.closeButtonVisiblityProperty, Visibility.collapsed);
           
      b.background = _tabBackground;
      
      b.borderThickness = new Thickness.specified(1, 1, 0, 1);
    }
    
//    print('switch to ${getValue(tab.headerProperty)}');
    currentTab = tab;
    
    final t = currentTab._visualTemplate;
      //set active markings on the tab.
      
    _tabBackground = getValue(t.backgroundProperty);
    
    setValue(currentTab.closeButtonVisiblityProperty, Visibility.visible);
    
    currentTab._visualTemplate.borderThickness = 
        new Thickness.specified(2, 2, 0, 2);
    
    setValue(t.backgroundProperty, 
        getValue(tabSelectedBrushProperty));
    
    setValue(currentContentProperty, 
        getValue(currentTab.contentProperty));

  }

  void closeTab(TabItem tab){
    //TODO add handling for last tab closed.
    if (tabItems.length == 1) return;
      
    tab._visualTemplate.rawElement.remove();
    
    tabItems.removeRange(tabItems.indexOf(tab), 1);
    
    currentTab = null;
    
    switchToTab(tabItems[0]);
    
  }
  
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
      ti._visualTemplate = e;
      e.mouseUp + (_, __){
        tabSelected.invokeAsync(this, new TabSelectedEventArgs(ti));
      };
      
      final b = Template.findByName('__close_button__', e);
      assert(b != null);
      
      b.mouseUp + (_, __){
        tabClosing.invokeAsync(this, new TabSelectedEventArgs(ti));
      };
    });

    tabSelected + (_, args){
      switchToTab(args.tab);
    };
    
    tabClosing + (_, args){
      closeTab(args.tab);
    };
    
    switchToTab(tabItems[0]);
    
  }
  
  void _initTabContainerProperties(){
    currentContentProperty = new FrameworkProperty(this, 'currentContent');

    tabItemsProperty = new FrameworkProperty(this, 'tabItems',
        defaultValue: new List<FrameworkObject>());

    tabAlignmentProperty = new FrameworkProperty(this, 'tabAlignment',
        defaultValue: HorizontalAlignment.left,
        converter: const StringToHorizontalAlignmentConverter());
    
    tabSelectedBrushProperty = new FrameworkProperty(this, 'tabSelectedBrush',
        defaultValue: new SolidColorBrush(new Color.predefined(Colors.White)),
        converter: const StringToSolidColorBrushConverter());
    
    backgroundProperty = new FrameworkProperty(this, 'background',
        defaultValue: new SolidColorBrush(new Color.predefined(Colors.White)),
        converter: const StringToSolidColorBrushConverter());
    
  }

  List<FrameworkObject> get tabItems => getValue(tabItemsProperty);
  

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
     <grid valign='{template vAlign}' halign='{template hAlign}' height='{template height}' width='{template width}'>
        <rowdefinitions>
           <rowdefinition height='auto' />
           <rowdefinition height='*' />
        </rowdefinitions>
        <collectionpresenter name='__tc_presenter__' halign='{template tabAlignment}' collection='{template tabItems}'>
           <presentationpanel>
              <stack orientation='horizontal' />
           </presentationpanel>
           <itemstemplate>
              <border valign='stretch' cornerradius='7,7,0,0' cursor='Arrow' background='WhiteSmoke' borderthickness='1,1,0,1' bordercolor='Gray' padding='2'>
                 <stack orientation='horizontal'>
                    <contentpresenter content='{data icon}' margin='0,2,0,0' />
                    <contentpresenter content='{data header}' margin='0,3,0,0' />
                    <border margin='0,2,0,3' valign='top' width='13' height='13' padding='0,0,2,0'>
                      <border name='__close_button__' borderColor='Gray' borderthickness='1' halign='stretch' valign='stretch' visibility='{data closeButtonVisibility}'>
                          <actions>
                             <setproperty event='mouseEnter' property='background' value='Orange' />
                             <setproperty event='mouseLeave' property='background' value='White' />
                             <setproperty event='mouseDown' property='background' value='#CCCCCC' />
                             <setproperty event='mouseUp' property='background' value='Orange' />
                          </actions>
                          <textblock text='X' foreground='Gray' valign='center' halign='center' fontfamily='Arial' fontsize='10' />
                      </border>
                    </border>
                 </stack>
              </border>
           </itemstemplate>
        </collectionpresenter>
        <border grid.row='1' halign='stretch' bordercolor='Gray' borderthickness='1' valign='stretch' background='{template background}' padding='5'>
            <contentpresenter content='{template currentContent}' />
        </border>
     </grid>
  </template>
</controltemplate>
''';
  }
}

