// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('youtube.media.controls.buckshotui.org');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:buckshot/web/web.dart');

class YouTube extends FrameworkElement
{
  FrameworkProperty<String> videoID;

  YouTube(){
    Browser.appendClass(rawElement, "youtube");

    _initializeYouTubeProperties();
  }

  YouTube.register() : super.register();
  makeMe() => new YouTube();


  void _initializeYouTubeProperties(){
    videoID = new FrameworkProperty(this, "videoID", (String value){
      rawElement.attributes["src"] = 'http://www.youtube.com/embed/${value.toString()}?wmode=transparent';
    });
  }

  void createElement(){
    rawElement = new Element.tag("iframe");
    Browser.appendClass(rawElement, 'youtube-player');
    rawElement.attributes["type"] = "text/html";
    rawElement.attributes["frameborder"] = "0";
  }
}
