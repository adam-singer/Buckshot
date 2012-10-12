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

  SetProperty.register() : super.register();
  makeMe() => new SetProperty();

  void _initSetPropertyActionProperties(){
    targetProperty = new FrameworkProperty(this, 'target');
    propertyProperty = new FrameworkProperty(this, 'property');
    valueProperty = new FrameworkProperty(this, 'value');
  }

  String get target => getValue(targetProperty);
  set target(String v) => setValue(targetProperty, v);

  String get property => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);

  Dynamic get value => getValue(valueProperty);
  set value(Dynamic v) => setValue(valueProperty, v);

  void onEventTrigger(){

    //TODO throw?
    if (property == null || value == null) return;

    var el = target != null
        ? namedElements[target]
        : getValue(_sourceProperty);

    if (el == null) return; //TODO throw?

    el
      .getPropertyByName(property)
      .then((prop){
        if (prop == null) return;

        setValue(prop, value);
      });
  }
}