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

/**
* Static helpers for working with the DOM. 
*
* **(deprecated)**
*/
class Dom {
  
  /// Appends the given [String] as a class to the given [Element].
  static void appendClass(Element element, String classToAppend){
    String currentClasses = element.attributes["class"];
    currentClasses = currentClasses == null || currentClasses == "null" ? "" : currentClasses;
    element.attributes["class"] = currentClasses != "" ? currentClasses + " " + classToAppend : classToAppend;
  }
  
  /// Creates an [Element] from the given [String] html tag name.
  static Element createByTag(String tagName){
    return new Element.tag(tagName);
  }
  
  /**
  * Injects javascript into the DOM, and optionally removes it after the script has run. */
  static void inject(String javascript, [bool removeAfter = false]){
    var s = Dom.createByTag("script");
    s.attributes["type"] = "text/javascript";
    s.text = javascript;
    
    window.document.body.nodes.add(s);
    
    if (removeAfter != null && removeAfter)
      s.remove();
  }
}

class _Dom{

  static void appendClass(Element element, String classToAppend){
    String currentClasses = element.attributes["class"];
    currentClasses = currentClasses == null || currentClasses == "null" ? "" : currentClasses;
    element.attributes["class"] = currentClasses != "" ? currentClasses + " " + classToAppend : classToAppend;
  }
  
  static Element createByTag(String tagName){
    return new Element.tag(tagName);
  }
  
  static void makeFlexBox(FrameworkElement element){
    var e = element._component;
    
    e.style.setProperty("display", "-webkit-box", null);   
    e.style.setProperty("display", "-moz-box", null);
    e.style.setProperty("display", "box", null);

  }
  
  static void setFlexBoxOrientation(FrameworkElement element, Orientation orientation){
    makeFlexBox(element);

    var e = element._component;
    
    switch(orientation){
    case Orientation.horizontal:
      e.style.setProperty("-webkit-box-orient", "horizontal", null);
      e.style.setProperty("-moz-box-orient", "horizontal", null);
      e.style.setProperty("box-orient","horizontal", null);
      break;
    case Orientation.vertical:
      e.style.setProperty("-webkit-box-orient", "vertical", null);
      e.style.setProperty("-moz-box-orient", "vertical", null);
      e.style.setProperty("box-orient","vertical", null);
      break;
    }
  }
  
  static void setHorizontalFlexBoxAlignment(FrameworkElement element, HorizontalAlignment alignment){
    makeFlexBox(element);
    
    var e = element._component;

    switch(alignment){
    case HorizontalAlignment.left:
      e.style.setProperty("-webkit-box-pack","start", null);
      e.style.setProperty("-moz-box-pack","start", null);
      e.style.setProperty("box-pack","start", null);
      break;
    case HorizontalAlignment.right:
      e.style.setProperty("-webkit-box-pack","end", null);
      e.style.setProperty("-moz-box-pack","end", null);
      e.style.setProperty("box-pack","end", null);
      break;
    case HorizontalAlignment.center:
      e.style.setProperty("-webkit-box-pack","center", null);
      e.style.setProperty("-moz-box-pack","center", null);
      e.style.setProperty("box-pack","center", null);
      break;
    case HorizontalAlignment.stretch:
      //this doesn't work as intended for boxes containing single items
//      e.style.setProperty("-webkit-box-pack", "justify", null);
//      e.style.setProperty("-moz-box-pack", "justify", null);
//      e.style.setProperty("box-pack", "justify", null);
      e.style.setProperty("-webkit-box-flex","1.0", null);
      e.style.setProperty("-moz-box-flex","1.0", null);
      e.style.setProperty("box-flex","1.0", null);
      
      //setFlexBoxOrientation(e, Orientation.vertical);
      break;
    }
  }
  
  static void setVerticalFlexBoxAlignment(FrameworkElement element, VerticalAlignment alignment){
    makeFlexBox(element);
    var e = element._component;
    
    switch(alignment){
      case VerticalAlignment.top:
        e.style.setProperty("-webkit-box-align","start", null);
        e.style.setProperty("-moz-box-align","start", null);
        e.style.setProperty("box-align","start", null);
        break;
      case VerticalAlignment.bottom:
        e.style.setProperty("-webkit-box-align","end", null);
        e.style.setProperty("-moz-box-align","end", null);
        e.style.setProperty("box-align","end", null);
        break;
      case VerticalAlignment.center:
        e.style.setProperty("-webkit-box-align","center", null);
        e.style.setProperty("-moz-box-align","center", null);
        e.style.setProperty("box-align","center", null);
        break;
      case VerticalAlignment.stretch:
        e.style.setProperty("-webkit-box-align","stretch", null);
        e.style.setProperty("-moz-box-align","stretch", null);
        e.style.setProperty("box-align","stretch", null);
        break;
    }
  }

}
