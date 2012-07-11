// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a setter/value pair for a [FrameworkProperty].
*/
class StyleSetter extends BuckshotObject
{
  FrameworkProperty valueProperty, propertyProperty;
  
  BuckshotObject makeMe() => new StyleSetter();
  
  StyleSetter(){
    _initStyleSetterProperties();
  }
  
  StyleSetter.with(String propertyName, Dynamic propertyValue)
  {
    _initStyleSetterProperties();
    property = propertyName;
    value = propertyValue;
  }

  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic newValue) => setValue(valueProperty, newValue);
  
  String get property() => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);
  
  void _initStyleSetterProperties(){
    valueProperty = new FrameworkProperty(this, "value", (v){});
    
    propertyProperty = new FrameworkProperty(this, "property", (String v){});
  }
  
  String get type() => "StyleSetter";
}
