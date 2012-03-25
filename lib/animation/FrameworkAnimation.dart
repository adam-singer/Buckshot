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
  String name;
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
  
  PropertyTransition(this.durationInSeconds, this.timing, [this.bezierValues = const [0,0,0,0]]);
}


class FrameworkAnimation
{
   
  BuckshotAnimation(){
    document.head.elements.add(new Element.html('<style id="__BuckshotStyle__">.luca_ui_textblock {font-size:30px;}</style>'));
  }
}


aTest(){
  document.head.elements.add(new Element.html('<style id="__BuckshotStyle__">.luca_ui_textblock {font-size:30px;}</style>'));
  StyleElement test = document.head.query('#__BuckshotStyle__');
  test.innerHTML = ".luca_ui_textblock {font-size:10px;}";
  //document.head.elements.add(new Element.html('<style>.luca_ui_textblock {font-size:10px;}</style>'));
   //new CSSStyleDeclaration.css(".luca_ui_textblock {font-size:30px}");
}

