// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class TransitionStateManager{
  static void goToState(String name, bool useTransitions){
    throw new NotImplementedException();
  }
}

class TransitionStateGroup{
  final List<TransitionState> states;
  
  TransitionStateGroup()
  :
  states = new List<TransitionState>()
  {
    
  }
}

class TransitionState{
  
}

class PropertyTransition
{
  final num durationInSeconds;
  final TransitionTiming timing;
  final List<num> bezierValues;
  final num delay;
  
  PropertyTransition(this.durationInSeconds, this.timing, [this.bezierValues = const [0,0,0,0], this.delay = 0]);
}


class FrameworkAnimation
{
  
  static void playAnimation(String name){
    
    AnimationResource anim = buckshot._resourceRegistry['$name'];
    
    if (anim == null) return;
    
    if (anim._cachedAnimation == null){
      _CssCompiler.compileAnimation(anim);
    }
    
    buckshot._buckshotCSS.innerHTML = '';
    buckshot._buckshotCSS.innerHTML = anim._cachedAnimation;
  }
  
  /// Low-level function that clears a CSS3 transition property for a given [AnimatingFrameworkProperty].
  static void clearPropertyTransition(AnimatingFrameworkProperty property){
    String transProp = Polly.getCSS(property.sourceObject.dynamic.rawElement, 'transition');
        
    if (transProp == null || !transProp.contains(property.cssPropertyPeer)) return;
    
    List props = transProp != null ? transProp.split(',') : [];
    
    if (props.length == 1){
      Polly.setCSS(property.sourceObject.dynamic.rawElement, 'transition', '');
      return;
    }

    int i = 0;
    int fi = -1;
        
    for (final String prop in props){
      if (prop.startsWith(property.cssPropertyPeer)){
        props.removeRange(i, 1);
        break;
      }
      i++;
    }
        
    StringBuffer sb = new StringBuffer();
    
    for(i = 0; i < props.length - 1; i++){
      sb.add('${props[i]},');
    }

    sb.add(props.last());
    
    Polly.setCSS(property.sourceObject.dynamic.rawElement, 'transition', sb.toString());
  }
  
  /// Low-level function that sets a CSS3 transition property for a given [AnimatingFrameworkProperty].
  static void setPropertyTransition(AnimatingFrameworkProperty property, PropertyTransition transition){
    
    String newProp = '${property.cssPropertyPeer} ${transition.durationInSeconds}s ${transition.timing} ${transition.delay}s';    
    
    String transProp = Polly.getCSS(property.sourceObject.dynamic.rawElement, 'transition');
    
    if (transProp == null){
      //create and return;
      Polly.setCSS(property.sourceObject.dynamic.rawElement, 'transition', newProp);
      return;
    }
    
    if (transProp != null && !transProp.contains(property.cssPropertyPeer)){
      //append and return;
      Polly.setCSS(property.sourceObject.dynamic.rawElement, 'transition', '${transProp}, $newProp');
      return;
    }

    //replace existing
    
    List props = transProp != null ? transProp.split(',') : [];
       
    int i = 0;
    int fi = -1;
        
    for (final String prop in props){
      if (prop.startsWith(property.cssPropertyPeer)){
        fi = i;
        break;
      }
      i++;
    }

    if (fi > -1)
      props[fi] = newProp;
    else
      props.add(newProp);
    
    StringBuffer sb = new StringBuffer();
    
    for(i = 0; i < props.length - 1; i++){
      sb.add('${props[i]},');
    }

    sb.add(props.last());
    
    Polly.setCSS(property.sourceObject.dynamic.rawElement, 'transition', sb.toString());
  }
  
  BuckshotAnimation(){
    document.head.elements.add(new Element.html('<style id="__BuckshotStyle__">.luca_ui_textblock {font-size:30px;}</style>'));
  }
}


//aTest(){
//  document.head.elements.add(new Element.html('<style id="__BuckshotCSS__"></style>'));
//  StyleElement test = document.head.query('#__BuckshotStyle__');
//  test.innerHTML = ".luca_ui_textblock {font-size:10px;}";
//  //document.head.elements.add(new Element.html('<style>.luca_ui_textblock {font-size:10px;}</style>'));
//   //new CSSStyleDeclaration.css(".luca_ui_textblock {font-size:30px}");
//}

