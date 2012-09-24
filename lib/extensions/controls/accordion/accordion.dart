// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('accordion.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

#source('accordion_item.dart');

class Accordion extends Control implements IFrameworkContainer
{
  FrameworkProperty accordionItemsProperty;
  FrameworkProperty backgroundProperty;
  FrameworkProperty selectionModeProperty;

  Accordion()
  {
    Browser.appendClass(rawElement, "Accordion");

    _initializeAccordianProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] =
        getValue(accordionItemsProperty);

    loaded + _initControl;
  }

  Accordion.register() : super.register(){
    buckshot.registerElement(new AccordionItem.register());
  }
  makeMe() => new Accordion();

  void _initializeAccordianProperties(){
    accordionItemsProperty = new FrameworkProperty(this, 'accordionItems',
        defaultValue: new List<FrameworkObject>());

    backgroundProperty = new FrameworkProperty(this, 'background',
        defaultValue: new SolidColorBrush(new Color.predefined(Colors.White)),
        converter: const StringToSolidColorBrushConverter());

    selectionModeProperty = new FrameworkProperty(this, 'selectionMode',
        defaultValue: SelectionMode.multi,
        converter: const StringToSelectionModeConverter());
  }

  get content => getValue(accordionItemsProperty);

  List<FrameworkObject> get accordionItems => getValue(accordionItemsProperty);

  void _initControl(sender, args){
    if (accordionItems.isEmpty()) return;

    final pc = (Template.findByName('__ac_presenter__', template)
        as CollectionPresenter)
        .presentationPanel
        .children;

    int i = 0;
    pc.forEach((e){
      final ai = accordionItems[i++];

      final header = Template.findByName('__accordion_header__', e);
      final body = Template.findByName('__accordion_body__', e);

      assert(header != null && body != null);

      body.visibility = ai.visibility;

      header.click + (_, __){
        body.visibility = (body.visibility == null
                          || body.visibility == Visibility.visible )
                            ? Visibility.collapsed
                            : Visibility.visible;
      };
    });
  }

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <border background='{template background}' valign='{template vAlign}' 
            halign='{template hAlign}' height='{template height}' 
            width='{template width}'
            cursor='Arrow'>
      <collectionpresenter halign='stretch' name='__ac_presenter__' collection='{template accordionItems}'>
         <itemstemplate>
            <stack halign='stretch'>
              $headerTemplate
              $bodyTemplate
            </stack>
         </itemstemplate>
      </collectionpresenter>
    </border>
  </template>
</controltemplate>
''';
  }

  /**
   * Override this template if you want to customize the look and feel of the
   * Accordion header.
   */
  String get headerTemplate =>
'''
 <border name='__accordion_header__' padding='5' borderthickness='0,0,1,0' bordercolor='DarkGray' background='WhiteSmoke' halign='stretch'>
    <actions>
      <setproperty event='mouseEnter' property='background' value='LightGray' />
      <setproperty event='mouseLeave' property='background' value='WhiteSmoke' />
      <setproperty event='mouseDown' property='background' value='DarkGray' />
      <setproperty event='mouseUp' property='background' value='LightGray' />
    </actions>
    <contentpresenter halign='stretch' content='{data header}' />                   
 </border>
''';

  /**
   * Override this template if you want to customize the look and feel of the
   * Accordion body.
   */
  String get bodyTemplate =>
'''
 <border name='__accordion_body__' halign='stretch' bordercolor='DarkGray'>
   <contentpresenter margin='5' halign='stretch' content='{data body}' />
 </border>
''';

}

class SelectionMode
{
  final _str;

  const SelectionMode(this._str);

  static const single = const SelectionMode('single');
  static const multi = const SelectionMode('multi');
}

class StringToSelectionModeConverter implements IValueConverter
{

  const StringToSelectionModeConverter();

  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    switch(value){
      case "single":
        return SelectionMode.single;
      case "multi":
        return SelectionMode.multi;
      default:
        throw const BuckshotException("Invalid SelectionMode value.");
      }
  }
}

