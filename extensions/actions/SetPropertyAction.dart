//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#library('extensions_actions_setpropertyaction');
#import('../../lib/Buckshot.dart');


/**
* Event-driven action that sets the property of a given element with a given value.
*/
class SetPropertyAction extends ActionBase
{
  FrameworkProperty propertyProperty;
  FrameworkProperty valueProperty;
  
  
  SetPropertyAction(){
    _initSetPropertyActionProperties();
  }
  
  void _initSetPropertyActionProperties(){
    propertyProperty = new FrameworkProperty(this, 'property', (_){});
    valueProperty = new FrameworkProperty(this, 'value', (_){});
  }
    
  String get property() => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);
  
  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic v) => setValue(valueProperty, v);
  
  BuckshotObject makeMe() => new SetPropertyAction();
  
  void onEventTrigger(){
   
    if (property == null || value == null)
      throw const FrameworkException('Event trigger failed because one or more properties is not assigned.');
    

    if (target == null){
      resolveTarget();
    }
    
    target.getPropertyByName(property).then((prop){
      if (prop == null) return;
      
      setValue(prop, value);  
    });
  }
  
  String get type() => "SetPropertyAction";
}
