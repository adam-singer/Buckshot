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
* DataTemplate provides a dynamic way to declare a group of [FrameworkProperty]'s
* at runtime.  This is useful for scenarios where you want to quickly work up
* an object to contain some dynamic record of data.
*
* Once populated, DataTemplate can be used in data binding scenarios with
* declarative Lucaxml files.
*
* ## See Also
* * Select the "Collections" example on the Buckshot Online Sandbox: [Try Buckshot](http://www.lucastudios.com/trybuckshot)
* * [Example view model that uses DataTemplate](https://github.com/prujohn/Buckshot/blob/master/demos/tryit/DemoViewModel.dart)
*/
class DataTemplate extends BuckshotObject{
  final HashMap<String, FrameworkProperty> _properties;
  
  BuckshotObject makeMe() => new DataTemplate();
  
  /// Constructs a DataTemplate with no properties.
  DataTemplate() 
  : _properties = new HashMap<String, FrameworkProperty>()
  {}
  
  /// Constructs a DataTemplate with property names from a given [List]. Values are left uninitialized.
  /// ### Example
  ///     new DataTemplate.fromList(["name","address","phone","age","sex"]);
  DataTemplate.fromList(List<String> propertyNames)
  : _properties = new HashMap<String, FrameworkProperty>()
  {
    propertyNames.forEach((String p){
      if (!(p is String)) throw const FrameworkException("Expect String property name in DataTemplate.fromList constructor list.");
      addProperty(p);
    });  
  }
  
  /// Constructs a DataTemplate with property/value pairs from a given [Map].
  /// ### Example
  ///     new DataTemplate.fromMap({"name":"John","address":"123 Main St","phone":"555-555-5555","age":"27","sex":"M"});
  DataTemplate.fromMap(Map<String, Dynamic> propertyMap)
  : _properties = new HashMap<String, FrameworkProperty>()
  {
    propertyMap.forEach((String p, v){
      if (!(p is String)) throw const FrameworkException("Expect String property name in DataTemplate.fromList constructor list.");
      addProperty(p, v);
    });
  }

  /// Sets a property's value in the DataTemplate.
  void setV(String propertyName, Dynamic value) => setValue(_properties[propertyName], value);
  
  /// Gets a property's value from the DataTemplate.
  Dynamic getV(String propertyName) => getValue(_properties[propertyName]); 

  /// Adds a new [FrameworkProperty] to the DataTemplate with optional default data and callback.
  void addProperty(String propertyName, [Dynamic defaultData = null, Function changedCallback = null]){
    if (_properties.containsKey(propertyName))
      throw new FrameworkException("Property name '${propertyName}' already exists in DataTemplate properties.");
    
    if (defaultData == null && changedCallback == null){
      _properties[propertyName] = new FrameworkProperty(this, propertyName, (_){});
      return;
    }
    
    if (defaultData != null && changedCallback == null){
      _properties[propertyName] = new FrameworkProperty(this, propertyName, (_){}, defaultData);
      return;
    }
    
    if (defaultData == null && changedCallback != null){
      _properties[propertyName] = new FrameworkProperty(this, propertyName, changedCallback);
      return;
    }
    
    //defaultData != null && changedCallback != null
    _properties[propertyName] = new FrameworkProperty(this, propertyName, changedCallback, defaultData);
  }
}
