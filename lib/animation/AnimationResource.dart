// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationResource extends FrameworkResource
{
  String _cachedAnimation;

  FrameworkProperty keyFramesProperty;

  //TODO add support for other CSS3 animation properties: easing, iteration, direction

  AnimationResource(){
    _initAnimationResourceProperties();

    this.stateBag[FrameworkObject.CONTAINER_CONTEXT] = keyFramesProperty;
  }

  _initAnimationResourceProperties(){

    keyFramesProperty = new FrameworkProperty(this, 'keyFrames', (_){
      _invalidate();
    }, new List<AnimationKeyFrame>());

  }

  void _invalidate(){
    _cachedAnimation = null;
    _CssCompiler.compileAnimation(this);
  }

  List<AnimationKeyFrame> get keyFrames() => getValue(keyFramesProperty);
  set keyFrames(List<AnimationKeyFrame> v) => setValue(keyFramesProperty, v);

  String get type() => 'AnimationResource';
}
