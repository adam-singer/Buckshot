// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* DataTemplate provides a dynamic way to declare a group of [FrameworkProperty]'s
* at runtime.  This is useful for scenarios where you want to quickly work up
* an object to contain some dynamic record of data.
*
* Once populated, DataTemplate can be used in data binding scenarios within
* declarative Buckshot templates.
*
* ## See Also ##
* * Select the "Collections" example on the Online Sandbox: [Try Buckshot](http://www.lucastudios.com/trybuckshot)
* * [Example view model that uses DataTemplate](https://github.com/prujohn/Buckshot/blob/master/demos/tryit/DemoViewModel.dart)
*/
class DataTemplate extends BuckshotObject{
  final HashMap<String, FrameworkProperty> _properties;

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
      if (!(p is String)) throw const BuckshotException("Expect String property name in DataTemplate.fromList constructor list.");
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
      if (!(p is String)) throw const BuckshotException("Expect String property name in DataTemplate.fromList constructor list.");
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
      throw new BuckshotException("Property name '${propertyName}' already exists in DataTemplate properties.");

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
