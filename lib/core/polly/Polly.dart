// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Polly is the cross-browser & cross-platform rendering facility for Buckshot.
 *
 * She be a harsh mistress, but aye, she be worth it on a cold winter's night.
 */
class Polly {

  /// List of vendor prefixes.
  static final prefixes = const ['','-webkit-','-moz-','-o-','-ms-'];

  static BrowserInfo _browserInfo;

  /**
   * Gets a [BrowserInfo] object representing various data
   * about the current browser context.
   */
  static BrowserInfo get browserInfo() {
    if (_browserInfo != null) return _browserInfo;

    _browserInfo = Browser.getBrowserInfo();

    return _browserInfo;
  }


  /**
   * Converts and element into a flexbox container.
   * Returns true if flexbox was created; false otherwise. */
  static bool makeFlexBox(FrameworkObject element){

    prefixes.forEach((String p){
      element.rawElement.style.display = '${p}box';
      element.rawElement.style.display = '${p}flexbox';
      element.rawElement.style.display = '${p}flex';
    });

    if (element.rawElement.style.display == null
        || !element.rawElement.style.display.endsWith('x')){
      return false;
    }

    return true;
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


  /**
   * Removes a given CSS property from an HTML element.
   *
   * Supports all common browser prefixes. */
  static void removeXPCSS(Element e, String property){
    for(final String p in prefixes){
      e.style.removeProperty('${p}${property}');
    }
  }


  /**
   * Assigns a value to a property of an element that ensures cross-browser
   * support.
   *
   * Supports all common browser prefixes.
   *
   * Returns true if property was successfully applied. */
  static bool setXPCSS(Element e, String property, String value){
    prefixes.forEach((String p){
     e.style.setProperty('${p}${property}', value, '1');
     });

    return getXPCSS(e, property) != null;
  }


  /**
   * Gets a value from a given property.
   * Supports all common browser prefixes. */
  static String getXPCSS(Element e, String property){

    for(final String p in prefixes){
      String result = e.style.getPropertyValue('${p}${property}');

      if (result != null) return result;
    }

    return null;
  }


  /**
   * Sets the flex [Orientation] of a flex box. */
  static void setFlexBoxOrientation(FrameworkElement element,
                                    Orientation orientation){
    element.rawElement.style.flexFlow =
    orientation == Orientation.vertical ? 'column' : 'row';
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
                        HorizontalAlignment alignment, [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element.parent);
    }

    void flexHandler(){
      //supporting the latest draft flex box spec

      Polly.setXPCSS(element.rawElement, 'flex', 'none');

      switch(alignment){
        case HorizontalAlignment.left:
          setXPCSS(element.rawElement, 'align-self', 'flex-start');
          break;
        case HorizontalAlignment.right:
          setXPCSS(element.rawElement, 'align-self', 'flex-end');
          break;
        case HorizontalAlignment.center:
          setXPCSS(element.rawElement, 'align-self', 'center');
          break;
        case HorizontalAlignment.stretch:
          setXPCSS(element.rawElement, 'align-self', 'stretch');
          break;
      }
    }

    void flexBoxHandler(){
      //supporting the current flex box spec

    }

    void noFlexHandler(){
      throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      default:
        noFlexHandler();
        break;
    }
  }

  /** For individual items within a flexbox, but only in the cross-axis. */
  static void setItemVerticalCrossAxisAlignment(FrameworkElement element,
                                                VerticalAlignment alignment,
                                                [FlexModel flexModel]){

    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element.parent);
    }

    void flexHandler(){
      Polly.setXPCSS(element.rawElement, 'flex', 'none');
      switch(alignment){
        case VerticalAlignment.top:
          setXPCSS(element.rawElement, 'align-self', 'flex-start');
          break;
        case VerticalAlignment.bottom:
          setXPCSS(element.rawElement, 'align-self', 'flex-end');
          break;
        case VerticalAlignment.center:
          setXPCSS(element.rawElement, 'align-self', 'center');
          break;
        case VerticalAlignment.stretch:
          setXPCSS(element.rawElement, 'align-self', 'stretch');
          break;
        }
    }

    void flexBoxHandler(){
      switch(alignment){
        case VerticalAlignment.top:
          setXPCSS(element.rawElement, 'flex-align', 'start');
          break;
        case VerticalAlignment.bottom:
          setXPCSS(element.rawElement, 'flex-align', 'end');
          break;
        case VerticalAlignment.center:
          setXPCSS(element.rawElement, 'flex-align', 'center');
          break;
        case VerticalAlignment.stretch:
          setXPCSS(element.rawElement, 'flex-align', 'stretch');
          break;
        }
    }

    void noFlexHandler(){
      throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      default:
        noFlexHandler();
        break;

    }
  }

  /**
   * Sets the horizontal alignment of children within
   * a given flex box container [element]. */
  static void setHorizontalFlexBoxAlignment(FrameworkElement element,
                                            HorizontalAlignment alignment,
                                            [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element);
    }

    void flexHandler(){
      switch(alignment){
        case HorizontalAlignment.left:
          setXPCSS(element.rawElement, 'justify-content', 'flex-start');
          break;
        case HorizontalAlignment.right:
          setXPCSS(element.rawElement, 'justify-content', 'flex-end');
          break;
        case HorizontalAlignment.center:
          setXPCSS(element.rawElement, 'justify-content', 'center');
          break;
        case HorizontalAlignment.stretch:
          setXPCSS(element.rawElement, 'justify-content', 'stretch');
          break;
      }
    }

    void flexBoxHandler(){
      switch(alignment){
        case HorizontalAlignment.left:
          element.rawElement.style.flexPack = 'start';
          break;
        case HorizontalAlignment.right:
          element.rawElement.style.flexPack = 'end';
          break;
        case HorizontalAlignment.center:
          element.rawElement.style.flexPack = 'center';
          break;
        case HorizontalAlignment.stretch:
          element.rawElement.style.flexPack = 'start';
          break;
      }
    }

    void noFlexHandler(){
      throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      default:
        noFlexHandler();
        break;
    }
  }


  /**
   * Sets the vertical alignment of children within
   * a given flex box container [element]. */
  static void setVerticalFlexBoxAlignment(FrameworkElement element,
                                          VerticalAlignment alignment,
                                          [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element);
    }

    void flexHandler(){
      switch(alignment){
        case VerticalAlignment.top:
          setXPCSS(element.rawElement, 'align-items', 'flex-start');
          break;
        case VerticalAlignment.bottom:
          setXPCSS(element.rawElement, 'align-items', 'flex-end');
          break;
        case VerticalAlignment.center:
          setXPCSS(element.rawElement, 'align-items', 'center');
          break;
        case VerticalAlignment.stretch:
          setXPCSS(element.rawElement, 'align-items', 'stretch');
          break;
      }
    }

    void flexBoxHandler(){
      switch(alignment){
        case VerticalAlignment.top:
          element.rawElement.style.flexAlign = 'start';
          break;
        case VerticalAlignment.bottom:
          element.rawElement.style.flexAlign = 'end';
          break;
        case VerticalAlignment.center:
          element.rawElement.style.flexAlign = 'center';
          break;
        case VerticalAlignment.stretch:
          element.rawElement.style.flexAlign = 'stretch';
          break;
      }
    }

    void noFlexHandler(){
      throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      default:
        noFlexHandler();
        break;
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

    void flexHandler(){
      // browser supports the latest draft flexbox spec

      if (element.hAlign != null){
        Polly.setXPCSS(element.rawElement, 'flex', 'none');

        if(element.hAlign == HorizontalAlignment.stretch){
          Polly.setXPCSS(element.rawElement, 'flex', '1 1 auto');
        }

        setHorizontalFlexBoxAlignment(element.parent, element.hAlign,
          FlexModel.Flex);
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent, element.vAlign,
          FlexModel.Flex);
      }
    }

    void flexBoxHandler(){
      //browser supports the current flexbox spec

      if (element.hAlign != null){
        if (element.hAlign == HorizontalAlignment.stretch){
          element._manualAlignmentHandler.enableHorizontalStretch();
        }else{
          //something else besides stretch
          element._manualAlignmentHandler.disableHorizontalStretch();

          setHorizontalFlexBoxAlignment(element.parent, element.hAlign,
            FlexModel.FlexBox);
        }
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent, element.vAlign,
          FlexModel.FlexBox);
      }
    }

    void noFlexHandler(){
      // TODO: handle all flex layouts manually...
      throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(FlexModel.getFlexModel(element.parent)){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      default:
        noFlexHandler();
    }
  }
}


