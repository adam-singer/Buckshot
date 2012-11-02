part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a setter/value pair for a [FrameworkProperty].
*/
class Setter extends TemplateObject
{
  FrameworkProperty<dynamic> value;
  FrameworkProperty<String> property;

  Setter(){
    _initStyleSetterProperties();
  }

  Setter.register() : super.register();
  makeMe() => new Setter();

  Setter.with(String propertyName, dynamic propertyValue)
  {
    _initStyleSetterProperties();
    property.value = propertyName;
    value.value = propertyValue;
  }

  void _initStyleSetterProperties(){
    value = new FrameworkProperty(this, "value");
    property = new FrameworkProperty(this, "property");
  }
}
