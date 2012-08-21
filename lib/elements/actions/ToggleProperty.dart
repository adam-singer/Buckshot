// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event-driven action that alternates the value of a property as each event occurs.
*/
class ToggleProperty extends ActionBase
{
  FrameworkProperty targetProperty;
  FrameworkProperty propertyProperty;
  FrameworkProperty firstValueProperty;
  FrameworkProperty secondValueProperty;

  Dynamic _currentValue;

  ToggleProperty(){
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

  void onEventTrigger(){

    //TODO throw?
    if (target == null || property == null || firstValue == null || secondValue == null) return;

    var el = buckshot.namedElements[target];

    if (el == null) return; //TODO throw?

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

  String get type() => "ToggleProperty";
}