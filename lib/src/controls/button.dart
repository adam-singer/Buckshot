part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A button control element.
*/
class Button extends Control implements FrameworkContainer
{
  /// Represents the content inside the button.
  FrameworkProperty<dynamic> content;

  Button()
  {
    Browser.appendClass(rawElement, "button");

    _initButtonProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;
  }

  void _initButtonProperties(){
    // Initialize FrameworkProperty declarations.
    content = new FrameworkProperty(this, 'content');

    margin.value = new Thickness.specified(0, 3, 3, 0);
    zOrder.value = 0;
  }

  Button.register() : super.register();
  makeMe() => new Button();

  get containerContent => content.value;

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <border shadowx='{resource theme_shadow_x}'
            shadowy='{resource theme_shadow_y}'
            shadowblur='{resource theme_shadow_blur}'
            zorder='32766'
            minwidth='20'
            minheight='20'
            background='{resource theme_button_background}'
            borderthickness='{resource theme_button_border_thickness}'
            bordercolor='{resource theme_button_border_color}'
            padding='{resource theme_border_padding}'
            cursor='Arrow'>
        <actions>
          <setproperty event='mouseEnter' property='background' value='{resource theme_button_background_hover}' />
          <setproperty event='mouseLeave' property='background' value='{resource theme_button_background}' />
          <setproperty event='mouseLeave' property='translateX' value='0' />
          <setproperty event='mouseLeave' property='translateY' value='0' />
          <setproperty event='mouseLeave' property='shadowX' value='{resource theme_shadow_x}' />
          <setproperty event='mouseLeave' property='shadowY' value='{resource theme_shadow_y}' />
          <setproperty event='mouseLeave' property='shadowSize' value='0' />
          <setproperty event='mouseDown' property='translateX' value='2' />
          <setproperty event='mouseDown' property='translateY' value='2' />
          <setproperty event='mouseDown' property='shadowX' value='0' />
          <setproperty event='mouseDown' property='shadowY' value='0' />
          <setproperty event='mouseDown' property='shadowSize' value='-1' />
          <setproperty event='mouseUp' property='translateX' value='0' />
          <setproperty event='mouseUp' property='translateY' value='0' />
          <setproperty event='mouseUp' property='shadowX' value='{resource theme_shadow_x}' />
          <setproperty event='mouseUp' property='shadowY' value='{resource theme_shadow_y}' />
          <setproperty event='mouseUp' property='shadowSize' value='0' />
        </actions>
        <contentpresenter halign='center' valign='center' content='{template content}' />
    </border>
  </template>
</controltemplate>
''';
  }
}
