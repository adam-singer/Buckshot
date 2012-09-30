// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/** Represents an item in a [Menu] control */
class MenuItem extends Control
{

  FrameworkProperty iconProperty;
  FrameworkProperty headerProperty;

  MenuItem()
  {
    Browser.appendClass(rawElement, "MenuItem");

    _initMenuItemProperties();
  }

  MenuItem.register() : super.register();
  makeMe() => new MenuItem();

  void _initMenuItemProperties()
  {
    iconProperty = new FrameworkProperty(this, 'icon');

    headerProperty = new FrameworkProperty(this, 'header');
  }

  get header => getValue(headerProperty);
  set header(value) => setValue(headerProperty, value);

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <stack orientation='horizontal' halign='stretch' maxheight='50'>
       <contentpresenter valign='center' minwidth='25' maxwidth='25' content='{template icon}' />
       <contentpresenter valign='center' maxwidth='300' margin='0,0,0,5' content='{template header}' />
    </stack>
  </template>
</controltemplate>
''';
  }
}
