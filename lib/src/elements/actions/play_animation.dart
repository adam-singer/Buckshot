// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class PlayAnimation extends ActionBase {

  FrameworkProperty animation;
  FrameworkProperty action;

  PlayAnimation(){
    _initAnimationActionProperties();
  }

  PlayAnimation.register() : super.register();
  makeMe() => new PlayAnimation();

  void _initAnimationActionProperties(){
    animation = new FrameworkProperty(this, 'animation');
    action= new FrameworkProperty(this, 'action');
  }

  void onEventTrigger(){
    if (animation.value == null || action.value == null) return;

    FrameworkAnimation.playAnimation(animation.value);
  }
}