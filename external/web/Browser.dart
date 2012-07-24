// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * # Low Level DOM/Browser Utilities #
 * 
 * ## Parse the user agent and retrieves information about the browser. ##
 * This is a singleton class, so multiple "new Browser()" calls
 * will always return the same object.
 *
 * ## Will attempt to provide the following: ##
 * * Browser Type (Chrome, Firefox, ...)
 * * Platform (Mobile, Desktop, Tablet)
 * * Mobile Type (iPhone, Android, ...)
 * * Major Version
 */
class Browser
{
  static final prefixes = const ['','-webkit-','-moz-','-o-','-ms-'];
  
  //Browser Type
  static final String DARTIUM = "Dartium";
  static final String CHROME = "Chrome";
  static final String FIREFOX = "Firefox";
  static final String IE = "IE";
  static final String OPERA = "Opera";
  static final String ANDROID = "Android";
  static final String SAFARI = "Safari";
  static final String LYNX = "Lynx";
  
  //Platform Type
  static final String MOBILE = "Mobile";
  static final String DESKTOP = "Desktop";
  static final String TABLET = "Tablet";
  
  
  //Mobile Type
  // ANDROID is used again for Android
  static final String IPHONE = "iPhone";
  static final String IPAD = "iPad";
  static final String WINDOWSPHONE = "Windows Phone";
    
  static final String UNKNOWN = "Unknown"; 
  
  static String ua;
  
  num version;
  String browser;
  String platform;
  String mobileType;
  
  /** Returns a [BrowserInfo] object for the current browser. */
  static BrowserInfo getBrowserInfo()
  { 
    ua = window.navigator.userAgent;
    return new BrowserInfo(_getBrowserType(), _getVersion(), _getPlatform(), _getMobileType());
  } 
    
  /** Appends the given [String] as a class to the given [Element]. */
  static void appendClass(Element element, String classToAppend){
    String currentClasses = element.attributes["class"];
    currentClasses = currentClasses == null || currentClasses == "null" ? "" : currentClasses;
    element.attributes["class"] = currentClasses != "" ? '$currentClasses $classToAppend' : classToAppend;
  }

  /** Converts and element into a flexbox container. */
  static void makeFlexBox(Element element){
    prefixes.forEach((String p){
      var pre = '${p}box'; //assigning here because some bug won't let me pass it directly in .setProperty
      element.style.display = pre;
      pre = '${p}flexbox';
      element.style.display = pre;
      pre = '${p}flex';
      element.style.display = pre;
    });
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
  

  /* Internals */
  
  static num _getVersion(){
    
    num getMajor(String ver){
      if (ver.contains('.')){
        return Math.parseInt(ver.substring(0, ver.indexOf('.')));
      }else{
        return Math.parseInt(ver);
      }
    }
    
    switch(_getBrowserType()){
      case DARTIUM:
      case CHROME:
        final s = ua.indexOf('Chrome/') + 7;
        final e = ua.indexOf(' ', s);
        return getMajor(ua.substring(s, e));
      case ANDROID:
        final s = ua.indexOf('Android ') + 8;
        final e = ua.indexOf(' ', s);
        return getMajor(ua.substring(s, e));
      case FIREFOX:
        final s = ua.indexOf('Firefox/') + 8;
        final e = ua.indexOf(' ', s);
        return getMajor(ua.substring(s, e));
    }
    
    return 0;
  }
  
  static String _getMobileType(){
    if (_getPlatform() == UNKNOWN || _getPlatform() == DESKTOP){
      return UNKNOWN;
    }
    
    switch(_getBrowserType()){
      case CHROME:
      case ANDROID:
        return ANDROID;
      case SAFARI:
        if (ua.contains('iPhone') || ua.contains('iPod')){
          return IPHONE;
        }
        
        if (ua.contains('iPad')){
          return IPAD;
        }
        
        return UNKNOWN;
      case IE:
        //TODO: "Surface" tablet
        return WINDOWSPHONE;
      case OPERA:
        if (ua.contains('Android')){
          return ANDROID;
        }
        if (ua.contains('iPhone')){
          return IPHONE;
        }
        if (ua.contains('iPad')){
          return IPAD;
        }
        if (ua.contains('Windows Mobile')){
          return WINDOWSPHONE;
        }
        
        return DESKTOP;
    }
    
    return UNKNOWN;
  }
  
  static String _getPlatform(){
    if (_getBrowserType() == UNKNOWN) return UNKNOWN;
    
    switch(_getBrowserType()){
      case DARTIUM:
        return DESKTOP;
      case ANDROID:
        return MOBILE;
      case CHROME:
        if (ua.contains('<Android Version>')){
          return (ua.contains('Mobile') ? MOBILE : TABLET);
        }
        return DESKTOP;
      case SAFARI:
        if (ua.contains('iPhone') || ua.contains('iPod')){
          return MOBILE;
        }
        
        if (ua.contains('iPad')){
          return TABLET;
        }
        
        return DESKTOP;
      case IE:
        if (ua.contains('Windows Phone')){
          return MOBILE;
        }
        
        //TODO: need UA for "Surface" tablet eventually
        
        return DESKTOP;
      case OPERA:
        if (ua.contains('Opera Tablet')){
          return TABLET;
        }
        if (ua.contains('Mini') || ua.contains('Mobile')){
          return MOBILE;
        }
        return DESKTOP;
    }
    
    return UNKNOWN;
  }
  
  static String _getBrowserType(){
    
    //source: http://www.zytrax.com/tech/web/browser_ids.htm
    if (ua.contains('(Dart)')) return DARTIUM;
    if (ua.contains('Chrome/')) return CHROME;
    if (ua.contains('Firefox/') || ua.contains('ThunderBrowse')) return FIREFOX;
    if (ua.contains('MSIE')) return IE;
    if (ua.contains('Opera')) return OPERA;
    if (ua.contains('Android')) return ANDROID;
    if (ua.contains('Safari')) return SAFARI;
    if (ua.contains('Lynx')) return LYNX;

    return UNKNOWN;
  }
}