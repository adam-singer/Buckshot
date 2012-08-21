// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/*
 * TODO:
 * custome slider that works horizontal and vertical.
 */

/**
* A slider control.
* NOTE: This may not render on some browsers. */
class Slider extends Control
{

  FrameworkProperty minProperty;
  FrameworkProperty maxProperty;
  FrameworkProperty stepProperty;
  FrameworkProperty valueProperty;

  Slider(){
    Browser.appendClass(rawElement, "slider");

    _initSliderProperties();

    _initSliderEvents();
  }

  void _initSliderEvents(){
    rawElement.on.change.add((e){
      if (value == rawElement.dynamic.value) return; //no change
      value = rawElement.dynamic.value;
      e.stopPropagation();
    });
  }

  void _initSliderProperties(){
    minProperty = new FrameworkProperty(this, "min", (num v){
      rawElement.attributes["min"] = v.toString();
    }, 0, converter:const StringToNumericConverter());

    maxProperty = new FrameworkProperty(this, "max", (num v){
      rawElement.attributes["max"] = v.toInt().toString();
    }, 100, converter:const StringToNumericConverter());

    stepProperty = new FrameworkProperty(this, "step", (num v){
      rawElement.attributes["step"] = v.toString();
    }, converter:const StringToNumericConverter());

    valueProperty = new FrameworkProperty(this, "value", (num v){
      rawElement.dynamic.value = v.toString();
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

  void createElement(){
    rawElement = new InputElement();
    rawElement.attributes["type"] = "range";
  }

  String get type() => "Slider";

  int _templatePriority() => 20;
}
