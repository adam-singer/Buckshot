part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


//intermediate data structure used during animation css compilation
class _CssAnimationObject{
  final StringBuffer css;
  final HashMap<String, dynamic> standardPropertyCarryOver;

  FrameworkElement concreteElement;

  _CssAnimationObject()
  :
    css = new StringBuffer(),
    standardPropertyCarryOver = new HashMap<String, dynamic>();
}

//compiles an AnimationResource object into valid css3
class _CssCompiler
{
  static void compileAnimation(AnimationResource anim){

    if (anim._cachedAnimation != null || anim.keyFrames.value == null || anim.keyFrames.value.length == 0) return;

    //sort keyframe by time
    sortKeyFrames(anim.keyFrames.value);

    if (anim.keyFrames.value[0].time.value < 0) {
      throw const AnimationException('keyframe start time is < 0');
    }

    //convert keyframe times to percentages
    computeKeyFramePercentages(anim.keyFrames.value);

    final HashMap<String, _CssAnimationObject> animHash = new HashMap<String, _CssAnimationObject>();

    AnimationKeyFrame previous;
    anim.keyFrames.value.forEach((AnimationKeyFrame k){

      //initialize any new elements
      k.states.value.forEach((AnimationState s){
        if (!animHash.containsKey(s.target.value)){
          animHash[s.target.value] = new _CssAnimationObject();
          final cm = getObjectByName(s.target.value);
          cm
          .newInstance('',[])
          .then((newElementMirror){
            animHash[s.target.value].concreteElement = newElementMirror.reflectee;
          });
          animHash[s.target.value].css.add('@keyframes ${anim.key}${s.target.value} { ');
          if (animHash[s.target.value].concreteElement == null) throw const AnimationException('Unable to find target name in object registry.');
        }
      });


      animHash.forEach((_, s){
        s.css.add(' ${k._percentage}% {');
      });

      //write the properties
      k.states.value.forEach((AnimationState s){
         _CssAnimationObject ao = animHash[s.target.value];
        //TODO: Convert to async handling.  Currently broken
        AnimatingFrameworkProperty prop = ao.concreteElement._getPropertyByName(s.property.value);
        if (prop == null){
          throw new AnimationException('Unable to find specified property: ${s.property.value}');
        }
        if (prop is! AnimatingFrameworkProperty) {
          throw new AnimationException('Attempted to animate property ${s.property.value} that is not type AnimatingFrameworkProperty.');
        }

        //set the value to the proxy element, then read back it's css output
        if (prop.propertyName == 'fill'){
          log('${prop.propertyName} ... ${s.value}');
        }

        prop.value = s.value;

        ao.standardPropertyCarryOver[prop.cssPropertyPeer] =
            Polly.getCSS(ao.concreteElement.rawElement, prop.value.cssPropertyPeer);

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

      sb.add('#${t} { ${Polly.generateCSS("animation", "${anim.key}${t} ${anim.keyFrames.value.last.time.value}s linear forwards")} }');

      compiledCSS.add(sb.toString());
    });

    anim._cachedAnimation = compiledCSS.toString();
  }

  static void computeKeyFramePercentages(List<AnimationKeyFrame> keyFrames){
    var span = keyFrames.last.time.value;

    for(int i = 0; i < keyFrames.length; i++){
      keyFrames[i]._percentage = (keyFrames[i].time.value / span) * 100;
    }
  }

  static void sortKeyFrames(List<AnimationKeyFrame> keyFrames){
    keyFrames.sort((a, b){
      if (a.time.value < b.time.value) return -1;
      if (a.time.value > b.time.value) return 1;
      return 0;
    });
  }
}