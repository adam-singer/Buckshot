// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a setter/value pair for a [FrameworkProperty].
*/
class Setter extends TemplateObject
{
  FrameworkProperty valueProperty;
  FrameworkProperty propertyProperty;

  Setter(){
    _initStyleSetterProperties();
  }
  
  Setter.register() : super.register();
  makeMe() => new Setter();

  Setter.with(String propertyName, Dynamic propertyValue)
  {
    _initStyleSetterProperties();
    property = propertyName;
    value = propertyValue;
  }

  get value => getValue(valueProperty);
  set value(newValue) => setValue(valueProperty, newValue);

  String get property => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);

  void _initStyleSetterProperties(){
    valueProperty = new FrameworkProperty(this, "value");

    propertyProperty = new FrameworkProperty(this, "property");
  }
}
