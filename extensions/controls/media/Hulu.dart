// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('hulu.media.controls.buckshotui.org');

#import('dart:html');
#import('../../../lib/Buckshot.dart');
#import('../../../external/web/web.dart');

class Hulu extends FrameworkElement
{
  Element embed;
  Element param1;
  FrameworkProperty videoIDProperty;

  Hulu(){
    Browser.appendClass(rawElement, "hulu");

    _initializeHuluProperties();

  }


  void _initializeHuluProperties(){
    videoIDProperty = new FrameworkProperty(this, "videoID", (String value){
      param1.attributes["src"] = 'http://www.hulu.com/embed/${value.toString()}';
      embed.attributes["src"] = 'http://www.hulu.com/embed/${value.toString()}';
    });
  }

  String get videoID => getValue(videoIDProperty);
  set videoID(String value) => setValue(videoIDProperty, value);

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
