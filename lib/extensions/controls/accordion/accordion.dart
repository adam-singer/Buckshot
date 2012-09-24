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
  
  Accordion()
  {
    Browser.appendClass(rawElement, "Accordion");
  }

  Accordion.register() : super.register(){
    buckshot.registerElement(new AccordionItem.register());
  }
  makeMe() => new Accordion();
  
  
  
  
  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <border valign='{template vAlign}' halign='{template hAlign}' height='{template height}' width='{template width}'>
      <collectionpresenter name='__ac_presenter__' collection='{template accordionItems}'>
         <itemstemplate>
            <stack>
               <contentpresenter content='{data header}' />
               <contentpresenter content='{data body}' />
            </stack>
         </itemstemplate>
      </collectionpresenter>
    </border>
  </template>
</controltemplate>
''';
  }
}
