// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.

/** 
 * Polly is the cross-browser & cross-platform rendering utility for Buckshot.
 * 
 * She's a harsh mistress, but aye, she be worth it.
 */
class Polly {
  static final prefixes = const ['','-webkit-','-moz-','-o-','-ms-'];
  
  static BrowserInfo _browserInfo;
  
  static BrowserInfo get browserInfo() {
    if (_browserInfo != null) return _browserInfo;
    
    _browserInfo = Browser.getBrowserInfo();
    
    return _browserInfo;
  }
  
  /** Converts and element into a flexbox container. */
  static void makeFlexBox(FrameworkObject element){
    
    prefixes.forEach((String p){
      var pre = '${p}box'; //assigning here because some bug won't let me pass it directly in .setProperty
      element.rawElement.style.display = pre;
      pre = '${p}flexbox';
      element.rawElement.style.display = pre;
      pre = '${p}flex';
      element.rawElement.style.display = pre;
    });
    
    if (element.rawElement.style.display == null || !element.rawElement.style.display.endsWith('x')){
      throw const BuckshotException('Unable to declare box model on element.');
    }
  }
  

  /** Returns a string representing a cross-browser CSS property assignment. */
  static String generateXPCSS(String declaration, String value){
    StringBuffer sb = new StringBuffer();

    prefixes.forEach((String p){
      sb.add('${p}${declaration}: ${value};');
    });

    return sb.toString();
  }

  /** Returns true if the given property is supported. */
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

  /** Removes a given CSS property from an HTML element. Supports all common browser prefixes. */
  static void removeXPCSS(Element e, String property){
    for(final String p in prefixes){
      var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
      e.style.removeProperty(pre);
    }
  }

  /** Returns true if able to set a a given CSS value/property. Supports all common browser prefixes.  */
  static bool attemptSetXPCSS(Element e, String property, String value){
    setXPCSS(e, property, value);
    return getXPCSS(e, property) != null;
  }

  /** Assigns a value to a property of an element that ensures cross-browser support. Supports all common browser prefixes.  */
  static void setXPCSS(Element e, String property, String value){
    prefixes.forEach((String p){
     var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
     e.style.setProperty(pre, value, '1');
     });
  }

  /** Gets a value from a given property.   Supports all common browser prefixes. */
  static String getXPCSS(Element e, String property){

    for(final String p in prefixes){
      var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
      String result = e.style.getPropertyValue(pre);

      if (result != null) return result;
    }

    return null;
  }

  static void setFlexBoxOrientation(Element element, Orientation orientation){
    setXPCSS(element, 'flex-direction', (orientation == Orientation.horizontal) ? 'row' : 'column');
  }

  /// For individual items within a flexbox, but only in the cross-axis.
  static void setHorizontalItemFlexAlignment(Element element, HorizontalAlignment alignment){
    switch(alignment){
      case HorizontalAlignment.left:
        setXPCSS(element, 'align-self', 'flex-start');
        break;
      case HorizontalAlignment.right:
        setXPCSS(element, 'align-self', 'flex-end');
        break;
      case HorizontalAlignment.center:
        setXPCSS(element, 'align-self', 'center');
        break;
      case HorizontalAlignment.stretch:
        setXPCSS(element, 'align-self', 'stretch');
        break;
      }
  }

  /// For individual items within a flexbox, but only in the cross-axis.
  static void setVerticalItemFlexAlignment(Element element, VerticalAlignment alignment){

    switch(alignment){
      case VerticalAlignment.top:
        setXPCSS(element, 'align-self', 'flex-start');
        break;
      case VerticalAlignment.bottom:
        setXPCSS(element, 'align-self', 'flex-end');
        break;
      case VerticalAlignment.center:
        setXPCSS(element, 'align-self', 'center');
        break;
      case VerticalAlignment.stretch:
        setXPCSS(element, 'align-self', 'stretch');
        break;
      }
  }

  static void setHorizontalFlexBoxAlignment(Element element, HorizontalAlignment alignment){
    switch(alignment){
      case HorizontalAlignment.left:
        setXPCSS(element, 'justify-content', 'flex-start');
        //element._component.style.flexPack = 'start';
        break;
      case HorizontalAlignment.right:
        setXPCSS(element, 'justify-content', 'flex-end');
        //element._component.style.flexPack = 'end';
        break;
      case HorizontalAlignment.center:
        setXPCSS(element, 'justify-content', 'center');
        //element._component.style.flexPack = 'center';
        break;
      case HorizontalAlignment.stretch:
        //TODO start?
        setXPCSS(element, 'justify-content', 'stretch');
        //element._component.style.flexPack = 'start';
        break;
      }
  }

  static void setVerticalFlexBoxAlignment(Element element, VerticalAlignment alignment){
    switch(alignment){
      case VerticalAlignment.top:
        setXPCSS(element, 'align-items', 'flex-start');
        //element._component.style.flexAlign = 'start';
        break;
      case VerticalAlignment.bottom:
        setXPCSS(element, 'align-items', 'flex-end');
        //element._component.style.flexAlign = 'end';
        break;
      case VerticalAlignment.center:
        setXPCSS(element, 'align-items', 'center');
        //element._component.style.flexAlign = 'center';
        break;
      case VerticalAlignment.stretch:
        setXPCSS(element, 'align-items', 'stretch');
        //element._component.style.flexAlign = 'stretch';
        break;
    }
  }
  
  
  static _BrowserImpl _platform;
  
  static void setPlatform()
  {
    if (_platform != null) return;
    
    switch(browserInfo.browser){
      case 'IE':
        _platform = new _IE();
        break;
      case 'Dartium':
        _platform = new _Chromium();
        break;
      case 'Chrome':
        _platform = new _Chrome();
        break;
      case 'Firefox':
        _platform = new _Mozilla();
        break;
      case 'Opera':
        _platform = new _Opera();
        break;
      case 'Android':
        _platform = new _Android();
        break;
      case 'Safari':
        _platform = new _Safari();
        break;
      default:
        _platform = new _Chrome();
        break;
    }
  }
  
  /**
   * Sets the alignment of a given [element] within it's parent 
   * [FrameworkElement].  This function assumes that the parent element
   * is already flexbox.
   */
  static void setFlexboxAlignment(FrameworkElement element){
    setXPCSS(element.rawElement, 'flex', 'none');
    
    if (element.hAlign != null){
      if(element.hAlign == HorizontalAlignment.stretch){
        setXPCSS(element.rawElement, 'flex', '1 1 auto');
      }
      
      setHorizontalFlexBoxAlignment(element.parent.rawElement, element.hAlign);
    }

    if (element.vAlign != null){
      setVerticalFlexBoxAlignment(element.parent.rawElement, element.vAlign);
    }
  }
}

class _Chrome implements _BrowserImpl
{

}

class _Mozilla implements _BrowserImpl
{

}

class _IE implements _BrowserImpl
{
  
}

class _Android implements _BrowserImpl
{
  
}

class _Chromium implements _BrowserImpl
{
  
}

class _Opera implements _BrowserImpl
{
  
}

class _Safari implements _BrowserImpl
{
  
}

class _BrowserImpl
{

}

class FlexModel{
  final int _val;
  
  const FlexModel(this._val);
  
  static final Box = const FlexModel(1);
  static final FlexBox = const FlexModel(2);
  static final Flex = const FlexModel(3);
  static final Manual = const FlexModel(4);
}
