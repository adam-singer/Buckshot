// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Polly is the cross-browser & cross-platform rendering facility for Buckshot.
 *
 * She be a harsh mistress, but aye, she be worth it on a cold winter's night.
 *
 * ## Stable Browsers ##
 * * Chromium
 * * Dartium
 * * Chrome v20+
 *
 * ## Limited Support ##
 * * Chrome for Android
 *
 * ## Unstable ##
 * * Firefox 14/15
 * * Safari
 * * IE 9
 */
class Polly {

  /// List of vendor prefixes.
  static const prefixes = const ['','-webkit-','-moz-','-o-','-ms-'];

  /// Browsers that support flex model, and at which version.
  static const _flexSupported = const {'Chrome' : 21, 'Dartium' : 21};


  static bool _supports;
  /** Returns true if the browser context supports the flex model spec. */
  static bool get supportsFlexModel {
    if (_supports != null) return _supports;

    _supports = (_flexSupported.containsKey(browserInfo.browser) &&
        Polly.browserInfo.version >= _flexSupported[browserInfo.browser]);

    return _supports;
  }

  /**
   * Gets a [BrowserInfo] object representing various data
   * about the current browser context.
   */
  static final BrowserInfo browserInfo = Browser.getBrowserInfo();

  /**
   * Returns a future containing the mouse coordinates within a give [element]
   * coordinate space.
   */
  static Future<SafePoint> localMouseCoordinate(Element element,
      num pageX, num pageY){

    final c = new Completer();

    if (browserInfo.browser != Browser.CHROME){
      element.rect.then((ElementRect r){
        c.complete(new SafePoint(pageX - r.bounding.left,
            pageY - r.bounding.top));
      });
    }else{
      final wkitPoint =
          window
          .webkitConvertPointFromPageToNode(element,
            new Point(pageX, pageY));
      c.complete(new SafePoint(wkitPoint.x, wkitPoint.y));
    }

    return c.future;
  }

  /**
   * Returns true if the framework is known to be compatible with
   * the browser type/version it is running in.
   */
  static bool get browserOK {

    if (browserInfo.browser == Browser.DARTIUM) return true;

    //Chrome(ium) v20+
    if (browserInfo.browser == Browser.CHROME){
      if (browserInfo.version >= 20) return true;
    }

    return false;
  }

  /**
   * Converts and element into a flexbox container. */
  static void makeFlexBox(Element element){
    assert(element != null);

    if (!Polly.supportsFlexModel) return;

    element.style.display = 'flex';
    element.style.display = '${browserInfo.vendorPrefix}flex';

  }


  /** Returns a string representing a cross-browser CSS property assignment. */
  static String generateCSS(String declaration, String value){
    StringBuffer sb = new StringBuffer();

    sb.add('${declaration}: ${value};');
    sb.add('${browserInfo.vendorPrefix}${declaration}: ${value};');

    return sb.toString();
  }


  /** Returns true if the given property is supported. */
  static bool checkCSS3Support(Element e, String property, String value){

    var result = getCSS(e, property);

    if (result != null) return true;

    try{
      setCSS(e, property, value);

      result = getCSS(e, property);

      if (result != null){
        removeCSS(e, property);
        return true;
      }
    }catch (_){
      return false;
    }

    return false;
  }


  /**
   * Removes a given CSS property from an HTML element.
   *
   * Supports all common browser prefixes. */
  static void removeCSS(Element e, String property){

    e.style.removeProperty('${property}');
    e.style.removeProperty('${Polly.browserInfo.vendorPrefix}${property}');

  }


  /**
   * Assigns a value to a property of an element that ensures cross-browser
   * support.
   *
   * Supports all common browser prefixes.
   *
   * Returns true if property was successfully applied. */
  static bool setCSS(Element e, String property, String value){

    e.style.setProperty('${property}', value, 'important');
    e.style.setProperty('${Polly.browserInfo.vendorPrefix}${property}', value);

    return getCSS(e, property) != null;
  }


  /**
   * Gets a value from a given property.
   *
   * Supports all common browser prefixes. */
  static String getCSS(Element e, String property){

    var result = e.style.getPropertyValue('${property}');

    if (result != null) return result;

    result = e.style
        .getPropertyValue('${Polly.browserInfo.vendorPrefix}${property}');

    return (result != null) ? result : null;
  }


  /**
   * Gets the flex [Orientation] of a flex box. */
  static Orientation getFlexBoxOrientation(FrameworkElement element) =>
    element.rawElement.style.flexFlow == null
    || element.rawElement.style.flexFlow == 'column'
        ? Orientation.vertical
        : Orientation.horizontal;


  /** For individual items within a flexbox, but only in the cross-axis. */
  static void setItemHorizontalCrossAxisAlignment(FrameworkElement element,
                        HorizontalAlignment alignment){

    Polly.setCSS(element.rawElement, 'flex', 'none');

    switch(alignment){
      case HorizontalAlignment.left:
        setCSS(element.rawElement, 'align-self', 'flex-start');
        break;
      case HorizontalAlignment.right:
        setCSS(element.rawElement, 'align-self', 'flex-end');
        break;
      case HorizontalAlignment.center:
        setCSS(element.rawElement, 'align-self', 'center');
        break;
      case HorizontalAlignment.stretch:
        setCSS(element.rawElement, 'align-self', 'stretch');
        break;
    }
  }

  /** For individual items within a flexbox, but only in the cross-axis. */
  static void setItemVerticalCrossAxisAlignment(FrameworkElement element,
                                                VerticalAlignment alignment){

    Polly.setCSS(element.rawElement, 'flex', 'none');
    switch(alignment){
      case VerticalAlignment.top:
        setCSS(element.rawElement, 'align-self', 'flex-start');
        break;
      case VerticalAlignment.bottom:
        setCSS(element.rawElement, 'align-self', 'flex-end');
        break;
      case VerticalAlignment.center:
        setCSS(element.rawElement, 'align-self', 'center');
        break;
      case VerticalAlignment.stretch:
        setCSS(element.rawElement, 'align-self', 'stretch');
        break;
    }
  }

  /**
   * Sets the horizontal alignment of children within
   * a given flex box container [element]. */
  static void setHorizontalFlexBoxAlignment(FrameworkObject element,
                                            HorizontalAlignment alignment){
    if (Polly.supportsFlexModel){
      switch(alignment){
        case HorizontalAlignment.left:
          setCSS(element.rawElement, 'justify-content', 'flex-start');
          break;
        case HorizontalAlignment.right:
          setCSS(element.rawElement, 'justify-content', 'flex-end');
          break;
        case HorizontalAlignment.center:
          setCSS(element.rawElement, 'justify-content', 'center');
          break;
        case HorizontalAlignment.stretch:
          setCSS(element.rawElement, 'justify-content', 'stretch');
          break;
      }
    }else{
      _polyfillLog.fine('setHorizontalFlexBoxAlignment called noFlexHandler()');
    }

  }


  /**
   * Sets the vertical alignment of children within
   * a given flex box container [element]. */
  static void setVerticalFlexBoxAlignment(FrameworkObject element,
                                          VerticalAlignment alignment){

    if (Polly.supportsFlexModel){
      switch(alignment){
        case VerticalAlignment.top:
          setCSS(element.rawElement, 'align-items', 'flex-start');
          break;
        case VerticalAlignment.bottom:
          setCSS(element.rawElement, 'align-items', 'flex-end');
          break;
        case VerticalAlignment.center:
          setCSS(element.rawElement, 'align-items', 'center');
          break;
        case VerticalAlignment.stretch:
          setCSS(element.rawElement, 'align-items', 'stretch');
          break;
      }
    }else{
      _polyfillLog.fine('setVerticalFlexBoxAlignment called noFlexHandler()');
    }

  }

  /**
   * Sets the alignment of a given [element] within it's parent
   * [FrameworkElement].
   *
   * This function assumes that the parent element is already flexbox.
   *
   * This function is suitable for flex containers with a single child
   * element.
   */
  static void setFlexboxAlignment(FrameworkElement element){
    _polyfillLog.fine('Setting flex alignment for ($element)');

    if (element.hAlign != null){
      Polly.setCSS(element.rawElement, 'flex', 'none');

      if(element.hAlign == HorizontalAlignment.stretch){
        Polly.setCSS(element.rawElement, 'flex', '1 1 auto');
      }

      setHorizontalFlexBoxAlignment(element.parent, element.hAlign.value);
    }

    if (element.vAlign != null){
      setVerticalFlexBoxAlignment(element.parent, element.vAlign.value);
    }
  }

  // Don't dump Polly!  She's a nice old gal.
  static void dump(){
    print('');
    print('Dear Polly,');
    print('${Polly.browserInfo}');
    print('Vendor Prefix: ${Polly.browserInfo.vendorPrefix}');
    print('Supports Flex? ${Polly.supportsFlexModel ? "Yes" : "No"}');
    print('window width/height: ${windowWidth} ${windowHeight}');
    print('${Browser.ua}');
    print('');
  }
}

/**
 * Holds an x,y point.  SafePoint is here because Point is in use by webkit.
 */
class SafePoint
{
  final num x;
  final num y;

  SafePoint(this.x, this.y);
}