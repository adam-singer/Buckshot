// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationState extends TemplateObject
{
  FrameworkProperty targetProperty;
  FrameworkProperty propertyProperty;
  FrameworkProperty valueProperty;

  AnimationState(){
    _initAnimationStateProperties();
  }

  _initAnimationStateProperties(){

    targetProperty = new FrameworkProperty(this, 'target');

    propertyProperty = new FrameworkProperty(this, 'property');

    valueProperty = new FrameworkProperty(this, 'value');
  }

  String get target() => getValue(targetProperty);
  set target(String v) => setValue(targetProperty, v);

  String get property() => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);

  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic v) => setValue(valueProperty, v);
}
