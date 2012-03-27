class AnimationKeyFrame extends BuckshotObject
{
  FrameworkProperty timeProperty;
  FrameworkProperty statesProperty;
  
  AnimationKeyFrame(){
    _initAnimationKeyFrameProperties();
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = statesProperty;
  }
  
  _initAnimationKeyFrameProperties(){
    timeProperty = new FrameworkProperty(this, 'time', (_){}, converter:const StringToNumericConverter());
    
    statesProperty = new FrameworkProperty(this, 'states', (_){}, new List<AnimationState>());
  }
  
  num get time() => getValue(timeProperty);
  set time(num v) => setValue(timeProperty, v);
  
  List<AnimationState> get states() => getValue(statesProperty);
  set states(List<AnimationState> v) => setValue(statesProperty, v);
  
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new AnimationKeyFrame();
  
  String get type() => 'AnimationKeyFrame';
}
