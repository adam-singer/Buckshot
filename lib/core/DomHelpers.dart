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

    document.body.nodes.add(s);

    if (removeAfter != null && removeAfter)
      s.remove();
  }

  static void setXPCSS(Element e, String declaration, String value) => _Dom.setXPCSS(e, declaration, value);
  static String getXPCSS(Element e, String declaration) => _Dom.getXPCSS(e, declaration);

}

class _Dom {

  static final prefixes = const ['','-webkit-','-moz-','-o-','-ms-'];

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

  static void makeFlexBox(FrameworkObject element){
    prefixes.forEach((String p){
      var pre = '${p}flexbox'; //assigning here because some bug won't let me pass it directly in .setProperty
      element._component.style.display = pre;
    });

  }

  static String generateXPCSS(String declaration, String value){
    StringBuffer sb = new StringBuffer();

    prefixes.forEach((String p){
      sb.add('${p}${declaration}: ${value};');
    });

    return sb.toString();
  }

  static bool checkCSS3Support(Element e, String property, String value){

    var result = getXPCSS(e, property);

    if (result != null) return true;

    setXPCSS(e, property, value);

    result = getXPCSS(e, property);

    if (result != null){
      removeXPCSS(e, property);
      return true;
    }

    return false;
  }

  static void removeXPCSS(Element e, String property){
    for(final String p in prefixes){
      var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
      e.style.removeProperty(pre);
    }
  }

  static bool attemptSetXPCSS(Element e, String property, String value){
    setXPCSS(e, property, value);
    return getXPCSS(e, property) != null;
  }

  static void setXPCSS(Element e, String property, String value){

    prefixes.forEach((String p){
     var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
     e.style.setProperty(pre, value);
     });
  }

  static String getXPCSS(Element e, String property){

    for(final String p in prefixes){
      var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
      String result = e.style.getPropertyValue(pre);

      if (result != null) return result;
    }

    return null;
  }

  static void setFlexBoxOrientation(FrameworkElement element, Orientation orientation){
    element._component.style.boxOrient = (orientation == Orientation.horizontal) ? 'horizontal' : 'vertical';

  }

  /// For individual items within a flexbox.
  static void setHorizontalItemFlexAlignment(FrameworkElement element, HorizontalAlignment alignment){

    switch(alignment){
      case HorizontalAlignment.left:
        setXPCSS(element.rawElement, 'flex-item-align', 'start');
        break;
      case HorizontalAlignment.right:
        setXPCSS(element.rawElement, 'flex-item-align', 'end');
        break;
      case HorizontalAlignment.center:
        setXPCSS(element.rawElement, 'flex-item-align', 'center');
        break;
      case HorizontalAlignment.stretch:
        setXPCSS(element.rawElement, 'flex-item-align', 'stretch');
        break;
      }

  }

  /// For individual items within a flexbox.
  static void setVerticalItemFlexAlignment(FrameworkElement element, VerticalAlignment alignment){

    switch(alignment){
      case VerticalAlignment.top:
        setXPCSS(element.rawElement, 'flex-item-align', 'start');
        break;
      case VerticalAlignment.bottom:
        setXPCSS(element.rawElement, 'flex-item-align', 'end');
        break;
      case VerticalAlignment.center:
        setXPCSS(element.rawElement, 'flex-item-align', 'center');
        break;
      case VerticalAlignment.stretch:
        setXPCSS(element.rawElement, 'flex-item-align', 'stretch');
        break;
      }

  }

  static void setHorizontalFlexBoxAlignment(FrameworkObject element, HorizontalAlignment alignment){
    switch(alignment){
      case HorizontalAlignment.left:
        element._component.style.flexPack = 'start';
        break;
      case HorizontalAlignment.right:
        element._component.style.flexPack = 'end';
        break;
      case HorizontalAlignment.center:
        element._component.style.flexPack = 'center';
        break;
      case HorizontalAlignment.stretch:
        element._component.style.flexPack = 'start';
        break;
      }
  }

  static void setVerticalFlexBoxAlignment(FrameworkObject element, VerticalAlignment alignment){
    switch(alignment){
      case VerticalAlignment.top:
        element._component.style.flexAlign = 'start';
        break;
      case VerticalAlignment.bottom:
        element._component.style.flexAlign = 'end';
        break;
      case VerticalAlignment.center:
        element._component.style.flexAlign = 'center';
        break;
      case VerticalAlignment.stretch:
        element._component.style.flexAlign = 'stretch';
        break;
    }
  }

}
