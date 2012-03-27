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

class AnimationResource extends FrameworkResource
{
  FrameworkProperty keyFramesProperty;
  
  BuckshotObject makeMe() => new AnimationResource();
  
  AnimationResource(){
    _initAnimationResourceProperties();
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = keyFramesProperty;
  }
    
  _initAnimationResourceProperties(){
    
    keyFramesProperty = new FrameworkProperty(this, 'keyFrames', (_){}, new List<AnimationKeyFrame>());
    
  }
  
  void compileAnimation(){
    
    //sort keyframe by time
    if (keyFrames.length == 0) return;
    
    _sortKeyFrames();
    
    if (keyFrames[0].time < 0)
      throw const AnimationException('keyframe start time is < 0');
    
    //compute the spread
    List<num> spread = new List<num>();
        
  }
  
  _sortKeyFrames(){
    keyFrames.sort((a, b){
      if (a.time < b.time) return -1;
      if (a.time > b.time) return 1;
      return 0;
    });
  }
  
  List<AnimationKeyFrame> get keyFrames() => getValue(keyFramesProperty);
  set keyFrames(List<AnimationKeyFrame> v) => setValue(keyFramesProperty, v);
  
  String get type() => 'AnimationResource';
}
