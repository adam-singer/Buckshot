// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('tabcontrol.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');

#source('tab_item.dart');
#source('tab_selected_event_args.dart');

class TabControl extends Control implements IFrameworkContainer
{
  FrameworkProperty<FrameworkElement> currentContent;
  FrameworkProperty<ObservableList<TabItem>> tabItems;
  FrameworkProperty<HorizontalAlignment> tabAlignment;
  FrameworkProperty<Brush> tabBackground;
  FrameworkProperty<Brush> tabSelectedBrush;
  FrameworkProperty<Brush> background;

  final FrameworkEvent<TabSelectedEventArgs> tabSelected =
      new FrameworkEvent<TabSelectedEventArgs>();
  final FrameworkEvent<TabSelectedEventArgs> tabClosing =
      new FrameworkEvent<TabSelectedEventArgs>();

  TabItem currentTab;
  Brush _tabBackground;

  TabControl()
  {
    Browser.appendClass(rawElement, "TabControl");

    _initTabContainerProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = tabItems.value;
  }

  TabControl.register() : super.register(){
    registerElement(new TabItem.register());
  }
  makeMe() => new TabControl();

  get containerContent => tabItems.value;

  void switchToTab(TabItem tab){
    if (currentTab == tab) return;

    if (currentTab != null){
      final b = currentTab._visualTemplate as Border;

      //remove active markings on this tab.
      currentTab.closeButtonVisiblity.value = Visibility.collapsed;

      b.background.value = _tabBackground;

      b.borderThickness.value = new Thickness.specified(1, 1, 0, 1);
    }

    currentTab = tab;

    final t = currentTab._visualTemplate as Panel;
      //set active markings on the tab.

    _tabBackground = t.background.value;

    currentTab.closeButtonVisiblity.value = Visibility.visible;

    (currentTab._visualTemplate as Border).borderThickness.value =
        new Thickness.specified(2, 2, 0, 2);

    t.background.value = tabSelectedBrush.value;

    currentContent.value = currentTab.content.value;
  }

  void closeTab(TabItem tab){
    //TODO add handling for last tab closed.
    if (tabItems.value.length == 1) return;

    tab._visualTemplate.rawElement.remove();

    tabItems.value.removeRange(tabItems.value.indexOf(tab), 1);

    currentTab = null;

    switchToTab(tabItems.value[0]);

  }

  void onFirstLoad(){
    if (tabItems.value.isEmpty()) return;

    // this is the collection of the visual elements representing each
    // tab
    final pc = (Template.findByName('__tc_presenter__', template)
                           as CollectionPresenter)
                        .presentationPanel
                        .value
                        .children;

    int i = 0;
    pc.forEach((e){
      final ti = tabItems.value[i++] as TabItem;
      ti.parent = this;
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

    switchToTab(tabItems.value[0]);

  }

  void _initTabContainerProperties(){
    currentContent = new FrameworkProperty(this, 'currentContent');

    tabItems= new FrameworkProperty(this, 'tabItems',
        defaultValue: new List<FrameworkObject>());

    tabAlignment = new FrameworkProperty(this, 'tabAlignment',
        defaultValue: HorizontalAlignment.left,
        converter: const StringToHorizontalAlignmentConverter());

    tabSelectedBrush = new FrameworkProperty(this, 'tabSelectedBrush',
        defaultValue: new SolidColorBrush(getResource('theme_background_light')),
        converter: const StringToSolidColorBrushConverter());

    background = new FrameworkProperty(this, 'background',
        defaultValue: new SolidColorBrush(getResource('theme_background_light')),
        converter: const StringToSolidColorBrushConverter());

  }

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
              <border valign='stretch' cursor='Arrow' background='{resource theme_background_dark}' margin='0,1,0,0' borderthickness='1,1,0,1' bordercolor='{resource theme_border_color}' padding='2'>
                 <stack orientation='horizontal'>
                    <contentpresenter content='{data icon}' margin='0,2,0,0' />
                    <contentpresenter content='{data header}' margin='0,3,0,0' />
                    <border margin='0,2,0,3' valign='top' width='13' height='13' padding='0,0,2,0'>
                      <border name='__close_button__' borderColor='{resource theme_border_color}' borderthickness='{resource theme_border_thickness}' halign='stretch' valign='stretch' visibility='{data closeButtonVisibility}'>
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
        <border name='__content_border__' content='{template currentContent}' 
                grid.row='1' 
                halign='stretch' 
                valign='stretch'
                bordercolor='{resource theme_border_color}' 
                borderthickness='{resource theme_border_thickness}' 
                background='{template background}' 
                padding='{resource theme_border_padding}' />
     </grid>
  </template>
</controltemplate>
''';
  }
}

