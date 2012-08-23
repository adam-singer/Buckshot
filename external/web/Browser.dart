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

  //Browser Type
  static const String DARTIUM = "Dartium";
  static const String CHROME = "Chrome";
  static const String FIREFOX = "Firefox";
  static const String IE = "IE";
  static const String OPERA = "Opera";
  static const String ANDROID = "Android";
  static const String SAFARI = "Safari";
  static const String LYNX = "Lynx";

  //Platform Type
  static const String MOBILE = "Mobile";
  static const String DESKTOP = "Desktop";
  static const String TABLET = "Tablet";


  //Mobile Type
  // ANDROID is used again for Android
  static final String IPHONE = "iPhone";
  static final String IPAD = "iPad";
  static final String WINDOWSPHONE = "Windows Phone";

  static final String UNKNOWN = "Unknown";

  static final Map<String, String> vendorPrefixMap = const
    {
     'Chrome' : '-webkit-',
     'Dartium' : '-webkit-',
     'Safari' : '-webkit-',
     'Android' : '-webkit-',
     'IE' : '-ms-',
     'Opera' : '-o-',
     'Firefox' : '-moz-',
     'Unknown' : ''
    };

  static String ua;

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

  /* Internals */

  static num _getVersion(){

    num getMajor(String ver){
      if (ver.contains('.')){
        return parseInt(ver.substring(0, ver.indexOf('.')));
      }else{
        return parseInt(ver);
      }
    }

    switch(_getBrowserType()){
      case DARTIUM:
      case CHROME:
        final s = ua.indexOf('Chrome/') + 7;
        var e = ua.indexOf(' ', s);

        if (e == -1){
          e = ua.length - 1;
        }

        return getMajor(ua.substring(s, e));
      case ANDROID:
        final s = ua.indexOf('Android ') + 8;
        var e = ua.indexOf(' ', s);

        if (e == -1){
          e = ua.length - 1;
        }

        return getMajor(ua.substring(s, e));
      case FIREFOX:
        final s = ua.indexOf('Firefox/') + 8;
        var e = ua.indexOf(' ', s);
        if (e == -1){
          e = ua.length - 1;
        }

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
      case FIREFOX:
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