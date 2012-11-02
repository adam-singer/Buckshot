part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event-driven action that alternates the value of a property as each event occurs.
*/
class ToggleProperty extends ActionBase
{
  FrameworkProperty<String> target;
  FrameworkProperty<String> property;
  FrameworkProperty<String> firstValue;
  FrameworkProperty<String> secondValue;

  dynamic _currentValue;

  ToggleProperty(){
    _initTogglePropertyActionProperties();
  }

  ToggleProperty.register() : super.register();
  makeMe() => new ToggleProperty();

  void _initTogglePropertyActionProperties(){
    target = new FrameworkProperty(this, 'target');
    property = new FrameworkProperty(this, 'property');
    firstValue = new FrameworkProperty(this, 'firstValue');
    secondValue = new FrameworkProperty(this, 'secondValue');
  }

  void onEventTrigger(){

    //TODO throw?
    if (property.value == null ||
        firstValue.value == null ||
        secondValue.value == null) { return;
    }

    var el = target.value != null
        ? namedElements[target.value]
        : _source.value;

    if (el == null) return; //TODO throw?

    el
      .getPropertyByName(property.value)
      .then((prop){
        if (prop == null) return;

        if (_currentValue == null){
          _currentValue = secondValue.value;
          prop.value = secondValue.value;
          return;
        }

        _currentValue = (_currentValue == firstValue.value)
                          ? secondValue.value
                          : firstValue.value;

        prop.value = _currentValue;
      });
  }
}