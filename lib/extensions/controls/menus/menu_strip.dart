part of menus_controls_buckshot;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class MenuStrip extends Control implements FrameworkContainer
{
  FrameworkProperty<ObservableList<Menu>> menus;
  FrameworkProperty<Orientation> orientation;

  final FrameworkEvent<MenuItemSelectedEventArgs> menuItemSelected =
      new FrameworkEvent<MenuItemSelectedEventArgs>();

  Menu _previousMenu;

  MenuStrip()
  {
    Browser.appendClass(rawElement, "MenuStrip");

    _initMenuStripProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = menus.value;

    registerEvent('menuitemselected', menuItemSelected);

  }

  MenuStrip.register() : super.register();
  makeMe() => new MenuStrip();

  void onFirstLoad(){
    if (menus.value.isEmpty) return;

    menus.value.forEach((Menu m){
      if (!m.menuItems.value.isEmpty){
        m.menuItemSelected + (sender, MenuItemSelectedEventArgs args){
          //just bubble the event
          menuItemSelected.invoke(sender, args);
        };
      }

      if (m.header != null){
        // gets the border surrounding the menu header content
        final b = (m.parent.parent as Stack).children[0] as Border;

        b.click + (_, __){
          if (m.visibility.value == Visibility.visible){
            m.hide();
            return;
          }
          hideAllMenus();
          if (m.menuItems.value.isEmpty){
              // item-less menu, so just send the menu in the sender of the
              // event..
              menuItemSelected.invoke(m, new MenuItemSelectedEventArgs(null));
          }else{
            m.show();
          }
        };
      }
    });
  }

  /**
   * Hides any currently open menus attached to the MenuStrip.
   */
  void hideAllMenus(){
    if (menus.value.isEmpty) return;

    menus.value.forEach((Menu m){
      if (!m.menuItems.value.isEmpty){
        m.hide();
      }
    });
  }

  void _initMenuStripProperties(){
    menus = new FrameworkProperty(this, 'menus',
        defaultValue: new ObservableList<Menu>());

    orientation = new FrameworkProperty(this, 'orientation',
        defaultValue: Orientation.horizontal,
        converter: const StringToOrientationConverter());
  }

  get containerContent => menus.value;


  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <border cursor='Arrow' background='{resource theme_menu_background_brush}'>
      <collectionpresenter halign='stretch' collection='{template menus}'>
         <presentationpanel>
            <stack orientation='{template orientation}'></stack>
         </presentationpanel>
         <itemstemplate>
           <stack>
              <border padding='{resource theme_border_padding}' background='{resource theme_menu_background_brush}' halign='stretch'>
                <actions>
                   <setproperty event='mouseEnter' property='background' value='{resource theme_menu_background_hover_brush}' />
                   <setproperty event='mouseLeave' property='background' value='{resource theme_menu_background_brush}' />
                   <setproperty event='mouseDown' property='background' value='{resource theme_menu_background_mouse_down_brush}' />
                   <setproperty event='mouseUp' property='background' value='{resource theme_menu_background_hover_brush}' />
                </actions>
                <contentpresenter content='{data header}' />
              </border>
              <contentpresenter content='{data}' />
           </stack>
         </itemstemplate>
      </collectionpresenter>
    </border>
  </template>
</controltemplate>
''';
  }
}
