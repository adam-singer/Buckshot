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


class EnumBase extends HashableObject{
  
}

/**
* Provides helper functions to assist with debugging LUCA UI.
*
* **(Caution: Experimental)** */
class FrameworkDebug {

  static HashMap<FrameworkProperty, EventHandlerReference> _registry;
    
  static _init(){
    if (_registry != null) return;
    _registry = new HashMap<FrameworkProperty, EventHandlerReference>();
  }
  
  static dumpStateBag(FrameworkElement element){
    if (element == null) return;
    
    db("Statebag Dump", element);
    
    element
    ._stateBag
    .forEach((String k, Dynamic v) => db("Key: $k, Value:${v.toString()}", element));
  }
  
  static traceProperty(FrameworkProperty propertyToTrace){
    if (!DEBUG) return;
    
    if (propertyToTrace == null)
      throw const FrameworkException("FrameworkProperty parameter is null.");
    
    _init();
    
    if (FrameworkDebug._registry.containsKey(propertyToTrace)) return;
    
    //TODO fix this.  will fail if LucaObject is passed in
    
    EventHandlerReference ref = propertyToTrace.propertyChanging + (FrameworkProperty property, PropertyChangingEventArgs e){
      print("[LUCA UI TRACE] FrameworkProperty '${property.propertyName}' [${property.sourceObject.name == '' ? '' : property.sourceObject.name}]', old value: ${e.oldValue.toString()}, new value: ${e.newValue.toString()}");
//      print("[LUCA UI TRACE] FrameworkProperty '${property.propertyName}' of Type '${property.sourceObject._type}[${property.sourceObject.name == '' ? '' : property.sourceObject.name}]', old value: ${e.oldValue.toString()}, new value: ${e.newValue.toString()}");

    };
    
    _registry[propertyToTrace] = ref;
  }
  
  static untraceProperty(FrameworkProperty propertyToUntrace){
    if (!DEBUG) return;
    
    if (propertyToUntrace == null)
      throw const FrameworkException("FrameworkProperty parameter is null.");
    
    _init();
    
    if (!FrameworkDebug._registry.containsKey(propertyToUntrace)) return;
    
    propertyToUntrace.propertyChanging - _registry[propertyToUntrace];
    
    _registry.remove(propertyToUntrace);
    
  }
}
