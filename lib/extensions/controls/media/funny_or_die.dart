// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('funnyordie.media.controls.buckshotui.org');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:buckshot/web/web.dart');

class FunnyOrDie extends FrameworkElement
{
  FrameworkProperty<String> videoID;

  FunnyOrDie(){
    Browser.appendClass(rawElement, "funnyordie");

    _initializeFunnyOrDieProperties();
  }

  FunnyOrDie.register() : super.register();
  makeMe() => new FunnyOrDie();

  void _initializeFunnyOrDieProperties(){
    videoID = new FrameworkProperty(this, "videoID", (String value){
      rawElement.attributes["src"] = 'http://www.funnyordie.com/embed/${value.toString()}';
    });
  }

  void createElement(){
    rawElement = new Element.tag("iframe");
    rawElement.attributes["frameborder"] = "0";
  }
}
