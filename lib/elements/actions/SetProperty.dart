// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event-driven action that sets the property of a given element with a given value.
*/
class SetProperty extends ActionBase
{
  FrameworkProperty targetProperty;
  FrameworkProperty propertyProperty;
  FrameworkProperty valueProperty;


  SetProperty(){
    _initSetPropertyActionProperties();
  }

  void _initSetPropertyActionProperties(){
    targetProperty = new FrameworkProperty(this, 'target', (_){});
    propertyProperty = new FrameworkProperty(this, 'property', (_){});
    valueProperty = new FrameworkProperty(this, 'value', (_){});
  }

  String get target() => getValue(targetProperty);
  set target(String v) => setValue(targetProperty, v);

  String get property() => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);

  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic v) => setValue(valueProperty, v);

  void onEventTrigger(){

    //TODO throw?
    if (target == null || property == null || value == null) return;

    var el = buckshot.namedElements[target];

    if (el == null) return; //TODO throw?

    var prop = el._getPropertyByName(property);

    if (prop == null) return;

    setValue(prop, value);
  }

  String get type() => "SetProperty";
}