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

  FrameworkProperty min;
  FrameworkProperty max;
  FrameworkProperty step;
  FrameworkProperty value;

  Slider(){
    Browser.appendClass(rawElement, "Slider");

    _initSliderProperties();

    _initSliderEvents();
  }

  Slider.register() : super.register();
  makeMe() => new Slider();

  void _initSliderEvents(){
    rawElement.on.change.add((e){
      final ie = rawElement as InputElement;
      if (value.value == ie.value) return; //no change
      value.value = ie.value;
      e.stopPropagation();
    });
  }

  void _initSliderProperties(){
    min = new FrameworkProperty(this, "min", (num v){
      rawElement.attributes["min"] = v.toString();
    }, 0, converter:const StringToNumericConverter());

    max= new FrameworkProperty(this, "max", (num v){
      rawElement.attributes["max"] = v.toInt().toString();
    }, 100, converter:const StringToNumericConverter());

    step = new FrameworkProperty(this, "step", (num v){
      rawElement.attributes["step"] = v.toString();
    }, converter:const StringToNumericConverter());

    value = new FrameworkProperty(this, "value", (num v){
      (rawElement as InputElement).value = v.toString();
    }, converter:const StringToNumericConverter());
  }

  void createElement(){
    rawElement = new InputElement();
    rawElement.attributes["type"] = "range";
  }

  get defaultControlTemplate => '';
}
