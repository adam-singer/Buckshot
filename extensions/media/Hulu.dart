//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

class Hulu extends FrameworkElement
{
  Element embed;
  Element param1;
  FrameworkProperty videoIDProperty;
  
  FrameworkObject makeMe() => new Hulu();
  
  Hulu(){
    Dom.appendClass(component, "luca_ui_hulu");
    
    _initializeHuluProperties();
    
  }
  
  
  void _initializeHuluProperties(){
    videoIDProperty = new FrameworkProperty(this, "videoID", (String value){
      param1.attributes["src"] = 'http://www.hulu.com/embed/${value.toString()}';
      embed.attributes["src"] = 'http://www.hulu.com/embed/${value.toString()}';
    });
  }
  
  String get videoID() => getValue(videoIDProperty);
  set videoID(String value) => setValue(videoIDProperty, value);
  
  void calculateWidth(int value){
    super.calculateWidth(value);
    if (actualWidth == null) return;
    component.attributes["width"] = '${actualWidth.toString()}px';
    embed.attributes["width"] = '${actualWidth.toString()}px';
  }
  
  void calculateHeight(int value){
    super.calculateHeight(value);
    if (actualHeight == null) return;
    component.attributes["height"] = '${actualHeight.toString()}px';
    embed.attributes["height"] = '${actualHeight.toString()}px';
  }
  
//  <object width="512" height="288">
//  <param name="movie" value="http://www.hulu.com/embed/QRNTv9APf02C6J_xFpY0Dg"></param>
//  <param name="allowFullScreen" value="true"></param>
//  <embed src="http://www.hulu.com/embed/QRNTv9APf02C6J_xFpY0Dg" type="application/x-shockwave-flash"  width="512" height="288" allowFullScreen="true"></embed>
//  </object>
  
  void CreateElement(){

    component = Dom.createByTag("object");
    param1 = Dom.createByTag("param");
    param1.attributes["name"] = "movie";

    Element param2 = Dom.createByTag("param");
    param2.attributes["name"] = "allowFullScreen";
    param2.attributes["value"] = "true";
    
    embed = Dom.createByTag("embed");
    embed.attributes["type"] = "application/x-shockwave-flash";
    embed.attributes["allowFullScreen"] = "true";

    
    component.nodes.add(param1);
    component.nodes.add(param2);
    component.nodes.add(embed);
  }
  
  String get _type() => "Hulu";
}
