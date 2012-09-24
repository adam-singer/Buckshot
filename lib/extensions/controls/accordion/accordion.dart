// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('accordion.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

#source('accordion_item.dart');

class Accordion extends Control implements IFrameworkContainer
{
  FrameworkProperty accordionItemsProperty;
  FrameworkProperty backgroundProperty;
  
  Accordion()
  {
    Browser.appendClass(rawElement, "Accordion");
    
    _initializeAccordianProperties();
    
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = 
        getValue(accordionItemsProperty);
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
  }
    
  get content => getValue(accordionItemsProperty);
    
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
               <border padding='5' borderthickness='0,0,1,0' bordercolor='DarkGray' background='WhiteSmoke' halign='stretch'>
                  <contentpresenter halign='stretch' content='{data header}' />                   
               </border>
               <border padding='5'>
                 <contentpresenter halign='stretch' content='{data body}' />
               </border>
            </stack>
         </itemstemplate>
      </collectionpresenter>
    </border>
  </template>
</controltemplate>
''';
  }
}
