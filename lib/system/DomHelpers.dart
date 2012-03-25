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
*/
class Dom {
  
  /// Appends the given [String] as a class to the given [Element].
  static void appendClass(Element element, String classToAppend){
    String currentClasses = element.attributes["class"];
    currentClasses = currentClasses == null || currentClasses == "null" ? "" : currentClasses;
    element.attributes["class"] = currentClasses != "" ? currentClasses + " " + classToAppend : classToAppend;
  }
  
  /// Creates an [Element] from the given [String] html tag name.
  static Element createByTag(String tagName) => new Element.tag(tagName);
  
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

  static void appendBuckshotClass(Element element, String classToAppend){
    _Dom.appendClass(element, 'buckshot_' + classToAppend);
  }
  
  static void appendClass(Element element, String classToAppend){
    String currentClasses = element.attributes["class"];
    currentClasses = currentClasses == null || currentClasses == "null" ? "" : currentClasses;
    element.attributes["class"] = currentClasses != "" ? currentClasses + " " + classToAppend : classToAppend;
  }
  
  static Element createByTag(String tagName){
    return new Element.tag(tagName);
  }
  
  static void makeFlexBox(FrameworkElement element){
    element._component.style.setProperty("display", "box");
    element._component.style.setProperty("display", "-webkit-box");
    element._component.style.setProperty("display", "-moz-box");
    element._component.style.setProperty("display", "-o-box");
    element._component.style.setProperty("display", "-ms-box");
  }
  
  static void setXPCSS(Element e, String declaration, String value){
    e.style.setProperty('-webkit-${declaration}', value);
    e.style.setProperty('-moz-${declaration}', value);
    e.style.setProperty('-o-${declaration}', value);
    e.style.setProperty('-ms-${declaration}', value);
    e.style.setProperty(declaration, value);
  }
  
  static void setFlexBoxOrientation(FrameworkElement element, Orientation orientation){
    
    makeFlexBox(element);
    
    if (orientation == Orientation.horizontal){
      setXPCSS(element._component, 'box-orient', 'horizontal');      
    }else{
      setXPCSS(element._component, 'box-orient', 'vertical'); 
    }
  }
  
  static void setHorizontalFlexBoxAlignment(FrameworkElement element, HorizontalAlignment alignment){
    
    makeFlexBox(element);
    
    switch(alignment){
      case HorizontalAlignment.left:
        setXPCSS(element._component, 'box-pack', 'start'); 
        break;
      case HorizontalAlignment.right:
        setXPCSS(element._component, 'box-pack', 'end'); 
        break;
      case HorizontalAlignment.center:
        setXPCSS(element._component, 'box-pack', 'center'); 
        break;
      case HorizontalAlignment.stretch:
        //this doesn't work as intended for boxes containing single items
        //_setXPCSS(element._component, 'box-pack', 'justify'); 
        setXPCSS(element._component, 'box-flex', '1.0'); 
        break;
      }
  }
  
  static void setVerticalFlexBoxAlignment(FrameworkElement element, VerticalAlignment alignment){
    
    makeFlexBox(element);
    
    switch(alignment){
      case VerticalAlignment.top:
        setXPCSS(element._component, 'box-align', 'start'); 
        break;
      case VerticalAlignment.bottom:
        setXPCSS(element._component, 'box-align', 'end'); 
        break;
      case VerticalAlignment.center:
        setXPCSS(element._component, 'box-align', 'center'); 
        break;
      case VerticalAlignment.stretch:
        setXPCSS(element._component, 'box-align', 'stretch'); 
        break;
    }
  }

}
