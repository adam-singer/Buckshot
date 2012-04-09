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

/**
* Event-driven action that alternates the value of a property as each event occurs.
*/
class TogglePropertyAction extends ActionBase 
{
  FrameworkProperty targetProperty;
  FrameworkProperty propertyProperty;
  FrameworkProperty firstValueProperty;
  FrameworkProperty secondValueProperty;
  
  Dynamic _currentValue;
  
  TogglePropertyAction(){
    _initTogglePropertyActionProperties();
  }
  
  void _initTogglePropertyActionProperties(){
    targetProperty = new FrameworkProperty(this, 'target', (_){});
    propertyProperty = new FrameworkProperty(this, 'property', (_){});
    firstValueProperty = new FrameworkProperty(this, 'firstValue', (_){});
    secondValueProperty = new FrameworkProperty(this, 'secondValue', (_){});
  }
  
  String get target() => getValue(targetProperty);
  set target(String v) => setValue(targetProperty, v);
  
  String get property() => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);
  
  Dynamic get firstValue() => getValue(firstValueProperty);
  set firstValue(Dynamic v) => setValue(firstValueProperty, v);
  
  Dynamic get secondValue() => getValue(secondValueProperty);
  set secondValue(Dynamic v) => setValue(secondValueProperty, v);
  
  BuckshotObject makeMe() => new TogglePropertyAction();
  
  void onEventTrigger(){
    
    if (target == null || property == null || firstValue == null || secondValue == null)
      throw const FrameworkException('Event trigger failed because one or more properties is not assigned.');
      
    
    var el = Buckshot.namedElements[target];

    if (el == null)
      throw const FrameworkException('Event trigger failed because target was not found.');
    
    var prop = el._getPropertyByName(property);
    
    if (prop == null) return;
    
    if (_currentValue == null){
      _currentValue = secondValue;
      setValue(prop, secondValue);
      return;
    }
    
    _currentValue = (_currentValue == firstValue) ? secondValue : firstValue;
    
    setValue(prop, _currentValue);
    
  }
  
  String get type() => "TogglePropertyAction";
}
