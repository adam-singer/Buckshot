//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#library('extensions_actions_animationaction');
#import('../../lib/Buckshot.dart');


/**
* Event-driven action that directs a [AnimationResource] to start/stop/pause,
*  etc.
*/
class AnimationAction extends ActionBase {

  FrameworkProperty animationProperty;
  FrameworkProperty actionProperty;
  
  BuckshotObject makeMe() => new AnimationAction();
  
  AnimationAction(){
    _initAnimationActionProperties();
  }
  
  void _initAnimationActionProperties(){
    animationProperty = new FrameworkProperty(this, 'animation', (_){});
    actionProperty = new FrameworkProperty(this, 'action', (_){});
  }
  
  String get animation() => getValue(animationProperty);
  set animation(String value) => setValue(animationProperty, value);
  
  String get action() => getValue(actionProperty);
  set action(String value) => setValue(actionProperty, value);
  
  void onEventTrigger(){
    if (animation == null || action == null) return;
    
    // TODO use the action property to do more than
    // just play the animation. 
    FrameworkAnimation.playAnimation(animation);
  }
  
  String get type() => "AnimationAction";
}
