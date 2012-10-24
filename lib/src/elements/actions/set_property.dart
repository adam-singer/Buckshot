part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event-driven action that sets the property of a given element with a given value.
*/
class SetProperty extends ActionBase
{
  FrameworkProperty target;
  FrameworkProperty property;
  FrameworkProperty value;


  SetProperty(){
    _initSetPropertyActionProperties();
  }

  SetProperty.register() : super.register();
  makeMe() => new SetProperty();

  void _initSetPropertyActionProperties(){
    target = new FrameworkProperty(this, 'target');
    property = new FrameworkProperty(this, 'property');
    value = new FrameworkProperty(this, 'value');
  }

  void onEventTrigger(){

    //TODO throw?
    if (property.value == null || value.value == null) return;

    var el = target.value != null
        ? namedElements[target.value]
        : _source.value;

    if (el == null) return; //TODO throw?

    el
      .getPropertyByName(property.value)
      .then((prop){
        if (prop == null) return;

        prop.value = value.value;
      });
  }
}