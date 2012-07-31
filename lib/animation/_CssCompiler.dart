// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


//intermediate data structure used during animation css compilation
class _CssAnimationObject{
  final StringBuffer css;
  final HashMap<String, Dynamic> standardPropertyCarryOver;
  
  FrameworkElement concreteElement;
  
  _CssAnimationObject() 
  : 
    css = new StringBuffer(),
    standardPropertyCarryOver = new HashMap<String, Dynamic>();
}

//compiles an AnimationResource object into valid css3
class _CssCompiler
{   
  static void compileAnimation(AnimationResource anim){
    
    if (anim._cachedAnimation != null || anim.keyFrames == null || anim.keyFrames.length == 0) return;

    //sort keyframe by time    
    sortKeyFrames(anim.keyFrames);
       
    if (anim.keyFrames[0].time < 0)
      throw const AnimationException('keyframe start time is < 0');
           
    //convert keyframe times to percentages
    computeKeyFramePercentages(anim.keyFrames);
     
    final HashMap<String, _CssAnimationObject> animHash = new HashMap<String, _CssAnimationObject>();
    
    AnimationKeyFrame previous;
    anim.keyFrames.forEach((AnimationKeyFrame k){
      
      //initialize any new elements
      k.states.forEach((AnimationState s){
        if (!animHash.containsKey(s.target)){
          animHash[s.target] = new _CssAnimationObject();
          animHash[s.target].concreteElement = buckshot.namedElements[s.target].makeMe();
          animHash[s.target].css.add('@keyframes ${anim.key}${s.target} { ');
          if (animHash[s.target].concreteElement == null) throw const AnimationException('Unable to find target name in object registry.');
        }
      });
      

      animHash.forEach((_, s){
        s.css.add(' ${k._percentage}% {');
      });
      
      //write the properties      
      k.states.forEach((AnimationState s){        
         _CssAnimationObject ao = animHash[s.target];
        AnimatingFrameworkProperty prop = ao.concreteElement._getPropertyByName(s.property);
        if (prop == null){
          throw new AnimationException('Unable to find specified property: ${s.property}');
        }
        if (prop is! AnimatingFrameworkProperty) throw new AnimationException('Attempted to animate property ${s.property} that is not type AnimatingFrameworkProperty.');

        //set the value to the proxy element, then read back it's css output
        if (prop.propertyName == 'fill'){
          db('${prop.propertyName} ... ${s.value}');
        }
        
        setValue(prop, s.value);
        
        ao.standardPropertyCarryOver[prop.cssPropertyPeer] = Polly.getCSS(ao.concreteElement.rawElement, prop.cssPropertyPeer);

        //BUG dartbug.com/2232
        //style.borderRadius is returning null instead of assigned value.
        
      });

      //write out the keyframe
      animHash.forEach((t, ah){
        if (ah.standardPropertyCarryOver.length > 0){
          ah.standardPropertyCarryOver.forEach((kk, v){
            ah.css.add('${kk}: ${v};');
          });
        }
        ah.css.add('}');
      });      
    });
    
    //wrap in animation declaration and convert to multi browser
    StringBuffer compiledCSS = new StringBuffer();
    
    animHash.forEach((t, ah){
      ah.css.add(' } ');

      //now create the animation declarations

      StringBuffer sb = new StringBuffer();
      
      //create x-browser version of each animation
      Polly.prefixes.forEach((String p){
        String temp = ah.css.toString();
        temp = temp.replaceAll('@keyframes', '@${p}keyframes');
        temp = temp.replaceAll('transform', '${p}transform');
        sb.add(temp);
      });       

      sb.add('#${t} { ${Polly.generateCSS("animation", "${anim.key}${t} ${anim.keyFrames.last().time}s linear forwards")} }');
      
      compiledCSS.add(sb.toString());
    });

    anim._cachedAnimation = compiledCSS.toString();
  } 
  
  static void computeKeyFramePercentages(List<AnimationKeyFrame> keyFrames){
    var span = keyFrames.last().time;
            
    for(int i = 0; i < keyFrames.length; i++){
      keyFrames[i]._percentage = (keyFrames[i].time / span) * 100;
    }
  }
  
  static void sortKeyFrames(List<AnimationKeyFrame> keyFrames){
    keyFrames.sort((a, b){
      if (a.time < b.time) return -1;
      if (a.time > b.time) return 1;
      return 0;
    });
  }
}