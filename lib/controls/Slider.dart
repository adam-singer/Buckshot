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
    Dom.appendBuckshotClass(_component, "slider");

    _initSliderProperties();

    _initSliderEvents();
  }

  void _initSliderEvents(){
    _component.on.change.add((e){
      if (value == _component.dynamic.value) return; //no change
      value = _component.dynamic.value;
      e.stopPropagation();
    });
  }

  void _initSliderProperties(){
    minProperty = new FrameworkProperty(this, "min", (num v){
      _component.attributes["min"] = v.toString();
    }, 0, converter:const StringToNumericConverter());

    maxProperty = new FrameworkProperty(this, "max", (num v){
      _component.attributes["max"] = v.toInt().toString();
    }, 100, converter:const StringToNumericConverter());

    stepProperty = new FrameworkProperty(this, "step", (num v){
      _component.attributes["step"] = v.toString();
    }, converter:const StringToNumericConverter());

    valueProperty = new FrameworkProperty(this, "value", (num v){
      _component.dynamic.value = v.toString();
    }, converter:const StringToNumericConverter());
  }

  num get value() => getValue(valueProperty);
  set value(v) => setValue(valueProperty, v);

  num get step() => getValue(stepProperty);
  set step(v) => setValue(stepProperty, v);

  num get min() => getValue(minProperty);
  set min(v) => setValue(minProperty, v);

  num get max() => getValue(maxProperty);
  set max(v) => setValue(maxProperty, v);

  void CreateElement(){
    _component = new InputElement();
    _component.attributes["type"] = "range";
  }

  String get type() => "Slider";
}
