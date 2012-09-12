// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationKeyFrame extends TemplateObject
{
  FrameworkProperty timeProperty;
  FrameworkProperty statesProperty;
  num _percentage; //represents a conversion of time to a percentage along a time span
 // int _ordinal; //represents the ordinal order of the keyframe in an animation sequence

  //TODO add support for easing with 'animation-timing-function'

  AnimationKeyFrame(){
    _initAnimationKeyFrameProperties();

    this.stateBag[FrameworkObject.CONTAINER_CONTEXT] = statesProperty;
  }
  
  AnimationKeyFrame.register() : super.register();
  makeMe() => new AnimationKeyFrame();

  _initAnimationKeyFrameProperties(){
    timeProperty = new FrameworkProperty(this, 'time',
        converter:const StringToNumericConverter());

    statesProperty = new FrameworkProperty(this, 'states',
        defaultValue:new List<AnimationState>());
  }

  num get time => getValue(timeProperty);
  set time(num v) => setValue(timeProperty, v);

  List<AnimationState> get states => getValue(statesProperty);
  set states(List<AnimationState> v) => setValue(statesProperty, v);
}
