// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('media.controls.buckshotui.org');
#import('dart:html');
#import('../../../lib/Buckshot.dart');
#import('../../../external/web/web.dart');

class FunnyOrDie extends FrameworkElement
{
  FrameworkProperty videoIDProperty;
  
  FrameworkObject makeMe() => new FunnyOrDie();
  
  FunnyOrDie(){
    Browser.appendClass(rawElement, "funnyordie");
    
    _initializeFunnyOrDieProperties();
    
  }
  
  
  void _initializeFunnyOrDieProperties(){
    videoIDProperty = new FrameworkProperty(this, "videoID", (String value){
      rawElement.attributes["src"] = 'http://www.funnyordie.com/embed/${value.toString()}';
    });
  }
  
  String get videoID() => getValue(videoIDProperty);
  set videoID(String value) => setValue(videoIDProperty, value);
  
  
  void createElement(){
    rawElement = new Element.tag("iframe");
    rawElement.attributes["frameborder"] = "0";
  }
  
  String get type() => "FunnyOrDie";
}
