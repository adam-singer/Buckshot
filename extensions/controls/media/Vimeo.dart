// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('media.controls.buckshotui.org');
#import('dart:html');
#import('../../../lib/Buckshot.dart');
#import('../../../external/web/web.dart');

class Vimeo extends FrameworkElement
{
  FrameworkProperty videoIDProperty;
  
  FrameworkObject makeMe() => new Vimeo();
  
  Vimeo(){
    Browser.appendClass(rawElement, "vimeo");
    
    _initializeVimeoProperties();
    
  }
  
  
  void _initializeVimeoProperties(){
    videoIDProperty = new FrameworkProperty(this, "videoID", (String value){
      rawElement.attributes["src"] = 'http://player.vimeo.com/video/${value.toString()}';
    });
  }
  
  String get videoID() => getValue(videoIDProperty);
  set videoID(String value) => setValue(videoIDProperty, value);
  
  
  void createElement(){
    rawElement = new Element.tag("iframe");
    rawElement.attributes["frameborder"] = "0";
  }
  
  String get type() => "Vimeo";
}
