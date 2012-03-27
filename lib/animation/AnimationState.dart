class AnimationState extends FrameworkObject
{
  FrameworkProperty targetProperty;
  FrameworkProperty propertyProperty;
  FrameworkProperty valueProperty;
    
  AnimationState(){
    _initAnimationStateProperties();
  }
  
  _initAnimationStateProperties(){
    
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
    
  BuckshotObject makeMe() => new AnimationState();
    
  String get type() => 'AnimationState';
}
