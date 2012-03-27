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
  
  /// Low-level function that clears a CSS3 transition property for a given [AnimatingFrameworkProperty].
  static void clearPropertyTransition(AnimatingFrameworkProperty property){
    String transProp = _Dom.getXPCSS(property.sourceObject._component, 'transition');
        
    if (transProp == null || !transProp.contains(property.cssPropertyPeer)) return;
    
    List props = transProp != null ? transProp.split(',') : [];
    
    if (props.length == 1){
      _Dom.setXPCSS(property.sourceObject._component, 'transition', '');
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
    
    _Dom.setXPCSS(property.sourceObject._component, 'transition', sb.toString());
  }
  
  /// Low-level function that sets a CSS3 transition property for a given [AnimatingFrameworkProperty].
  static void setPropertyTransition(AnimatingFrameworkProperty property, PropertyTransition transition){
    
    String newProp = '${property.cssPropertyPeer} ${transition.durationInSeconds}s ${transition.timing} ${transition.delay}s';    
    
    String transProp = _Dom.getXPCSS(property.sourceObject._component, 'transition');
    
    if (transProp == null){
      //create and return;
      _Dom.setXPCSS(property.sourceObject._component, 'transition', newProp);
      return;
    }
    
    if (transProp != null && !transProp.contains(property.cssPropertyPeer)){
      //append and return;
      _Dom.setXPCSS(property.sourceObject._component, 'transition', '${transProp}, $newProp');
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
    
    _Dom.setXPCSS(property.sourceObject._component, 'transition', sb.toString());
  }
  
  BuckshotAnimation(){
    document.head.elements.add(new Element.html('<style id="__BuckshotStyle__">.luca_ui_textblock {font-size:30px;}</style>'));
  }
}


aTest(){
  document.head.elements.add(new Element.html('<style id="__BuckshotCSS__"></style>'));
  StyleElement test = document.head.query('#__BuckshotStyle__');
  test.innerHTML = ".luca_ui_textblock {font-size:10px;}";
  //document.head.elements.add(new Element.html('<style>.luca_ui_textblock {font-size:10px;}</style>'));
   //new CSSStyleDeclaration.css(".luca_ui_textblock {font-size:30px}");
}

