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

/**
* A slider control.
* NOTE: This may not render on some browsers. */
class Slider extends Control
{

  FrameworkProperty minProperty, maxProperty, stepProperty, valueProperty;
  
  FrameworkObject makeMe() => new Slider();
  
  Slider(){
    _Dom.appendClass(_component, "luca_ui_slider");
    
    _initSliderProperties();
    
    _initSliderEvents();
  }
  
  void _initSliderEvents(){
    _component.on.change.add((e){
      if (value == _component.dynamic.value) return; //no change
      
      int oldValue = value;
      value = _component.dynamic.value;
      
      if (e.cancelable) e.cancelBubble = true;  
    });    
  }
  
  void _initSliderProperties(){
    minProperty = new FrameworkProperty(this, "min", (int v){
      _component.attributes["min"] = v.toString();
    }, 0);
    
    maxProperty = new FrameworkProperty(this, "max", (int v){
      _component.attributes["max"] = v.toString();
    }, 100);
    
    stepProperty = new FrameworkProperty(this, "step", (int v){
      _component.attributes["step"] = v.toString(); 
    });
    
    valueProperty = new FrameworkProperty(this, "value", (int v){
      _component.attributes["value"] = v.toString();
    });
  }
  
  int get value() => getValue(valueProperty);
  set value(int v) => setValue(valueProperty, v);
  
  int get step() => getValue(stepProperty);
  set step(int v) => setValue(stepProperty, v);
  
  int get min() => getValue(minProperty);
  set min(int v) => setValue(minProperty, v);
  
  int get max() => getValue(maxProperty);
  set max(int v) => setValue(maxProperty, v);
    
  void CreateElement(){
    _component = _Dom.createByTag("input");
    _component.attributes["type"] = "range";
  }
  
  String get _type() => "Slider";
}
