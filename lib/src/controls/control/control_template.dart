// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A [FrameworkResource] which represents the initial visual representation of
* a [Control].
*/
class ControlTemplate extends FrameworkResource implements IFrameworkContainer
{
  FrameworkProperty<String> controlType;
  FrameworkProperty<FrameworkElement> template;

  ControlTemplate(){
    _initializeControlTemplateProperties();

    //redirect the resource finder to the template property
    //otherwise the ControlTemplate itself would be retrieved as the resource
    //this.stateBag[FrameworkResource.RESOURCE_PROPERTY] = templateProperty;
    this.stateBag[FrameworkObject.CONTAINER_CONTEXT] = template;

  }

  ControlTemplate.register() : super.register();
  makeMe() => new ControlTemplate();

  get containerContent => template.value;

  void _initializeControlTemplateProperties(){
    controlType = new FrameworkProperty(this, "controlType",
        defaultValue:"");

    template = new FrameworkProperty(this, "template");

    //key is not needed, so just shadow copy whatever the controlType is.
    bind(controlType, key);
  }
}
