// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class AnimationResource extends FrameworkResource
{
  String _cachedAnimation;

  FrameworkProperty<List<AnimationKeyFrame>> keyFrames;

  //TODO add support for other CSS3 animation properties: easing, iteration, direction

  AnimationResource(){
    _initAnimationResourceProperties();

    this.stateBag[FrameworkObject.CONTAINER_CONTEXT] = keyFrames;
  }

  AnimationResource.register() : super.register();
  makeMe() => new AnimationResource();

  _initAnimationResourceProperties(){

    keyFrames = new FrameworkProperty(this, 'keyFrames', (_){
      _invalidate();
    }, new List<AnimationKeyFrame>());

  }

  void _invalidate(){
    _cachedAnimation = null;
    _CssCompiler.compileAnimation(this);
  }
}
