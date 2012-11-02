// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library vimeo_media_controls_buckshotui_org;
import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:buckshot/web/web.dart';

class Vimeo extends FrameworkElement
{
  FrameworkProperty<String> videoID;

  Vimeo(){
    Browser.appendClass(rawElement, "vimeo");

    _initializeVimeoProperties();
  }

  Vimeo.register() : super.register();
  makeMe() => new Vimeo();

  void _initializeVimeoProperties(){
    videoID= new FrameworkProperty(this, "videoID",
        propertyChangedCallback: (String value){
      rawElement.attributes["src"] = 'http://player.vimeo.com/video/${value.toString()}';
    });
  }

  void createElement(){
    rawElement = new Element.tag("iframe");
    rawElement.attributes["frameborder"] = "0";
  }
}
