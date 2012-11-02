// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

library hulu_media_controls_buckshot;

import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:buckshot/web/web.dart';

class Hulu extends FrameworkElement
{
  Element embed;
  Element param1;
  FrameworkProperty<String> videoID;

  Hulu(){
    Browser.appendClass(rawElement, "hulu");

    _initializeHuluProperties();

  }

  Hulu.register() : super.register();
  makeMe() => new Hulu();

  void _initializeHuluProperties(){
    videoID = new FrameworkProperty(this, "videoID",
        propertyChangedCallback: (String value){
      param1.attributes["src"] = 'http://www.hulu.com/embed/${value.toString()}';
      embed.attributes["src"] = 'http://www.hulu.com/embed/${value.toString()}';
    });
  }

 void calculateWidth(value){
    super.calculateWidth(value);
    if (actualWidth == null) return;
    rawElement.attributes["width"] = '${actualWidth.toString()}px';
    embed.attributes["width"] = '${actualWidth.toString()}px';
  }

  void calculateHeight(value){
    super.calculateHeight(value);
    if (actualHeight == null) return;
    rawElement.attributes["height"] = '${actualHeight.toString()}px';
    embed.attributes["height"] = '${actualHeight.toString()}px';
  }

//  <object width="512" height="288">
//  <param name="movie" value="http://www.hulu.com/embed/QRNTv9APf02C6J_xFpY0Dg"></param>
//  <param name="allowFullScreen" value="true"></param>
//  <embed src="http://www.hulu.com/embed/QRNTv9APf02C6J_xFpY0Dg" type="application/x-shockwave-flash"  width="512" height="288" allowFullScreen="true"></embed>
//  </object>

  void createElement(){

    rawElement = new Element.tag("object");
    param1 = new Element.tag("param");
    param1.attributes["name"] = "movie";

    Element param2 = new Element.tag("param");
    param2.attributes["name"] = "allowFullScreen";
    param2.attributes["value"] = "true";

    embed = new Element.tag("embed");
    embed.attributes["type"] = "application/x-shockwave-flash";
    embed.attributes["allowFullScreen"] = "true";


    rawElement.nodes.add(param1);
    rawElement.nodes.add(param2);
    rawElement.nodes.add(embed);
  }
}
