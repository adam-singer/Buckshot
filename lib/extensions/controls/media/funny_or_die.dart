// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('funnyordie.media.controls.buckshotui.org');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dart_utils/web.dart');

class FunnyOrDie extends FrameworkElement
{
  FrameworkProperty videoIDProperty;

  FunnyOrDie(){
    Browser.appendClass(rawElement, "funnyordie");

    _initializeFunnyOrDieProperties();
  }

  FunnyOrDie.register() : super.register();
  makeMe() => new FunnyOrDie();
  
  void _initializeFunnyOrDieProperties(){
    videoIDProperty = new FrameworkProperty(this, "videoID", (String value){
      rawElement.attributes["src"] = 'http://www.funnyordie.com/embed/${value.toString()}';
    });
  }

  String get videoID => getValue(videoIDProperty);
  set videoID(String value) => setValue(videoIDProperty, value);


  void createElement(){
    rawElement = new Element.tag("iframe");
    rawElement.attributes["frameborder"] = "0";
  }
}
