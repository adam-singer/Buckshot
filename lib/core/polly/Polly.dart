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
  static BrowserInfo get browserInfo() => _browserInfo;

  static void init(){
    _browserInfo = Browser.getBrowserInfo();
  }


  /**
   * Returns true if the framework is known to be compatible with
   * the browser type/version it is running in.
   */
  static bool get browserOK() {

    if (browserInfo.browser == Browser.DARTIUM) return true;

    //Chrome(ium) v20+
    if (browserInfo.browser == Browser.CHROME){
      if (browserInfo.version >= 20) return true;
    }

    return false;
  }

  /**
   * Converts and element into a flexbox container.
   * Returns true if flexbox was created; false otherwise. */
  static bool makeFlexBox(FrameworkObject element){

    element.rawElement.style.display = 'box';
    element.rawElement.style.display = 'flexbox';
    element.rawElement.style.display = 'flex';

    element.rawElement.style.display = '${Polly.browserInfo.vendorPrefix}box';
    element.rawElement.style.display = '${Polly.browserInfo.vendorPrefix}flexbox';
    element.rawElement.style.display = '${Polly.browserInfo.vendorPrefix}flex';

    if (element.rawElement.style.display == null
        || !element.rawElement.style.display.endsWith('x')){
      return false;
    }

    return true;
  }


  /** Returns a string representing a cross-browser CSS property assignment. */
  static String generateXPCSS(String declaration, String value){
    StringBuffer sb = new StringBuffer();

    sb.add('${declaration}: ${value};');
    sb.add('${Polly.browserInfo.vendorPrefix}${declaration}: ${value};');

    return sb.toString();
  }


  /** Returns true if the given property is supported. */
  static bool checkCSS3Support(Element e, String property, String value){

    var result = getCSS(e, property);

    if (result != null) return true;

    setCSS(e, property, value);

    result = getCSS(e, property);

    if (result != null){
      removeCSS(e, property);
      return true;
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

    e.style.setProperty('${property}', value);
    e.style.setProperty('${Polly.browserInfo.vendorPrefix}${property}', value);

    return getCSS(e, property) != null;
  }


  /**
   * Gets a value from a given property.
   * Supports all common browser prefixes. */
  static String getCSS(Element e, String property){

    var result = e.style.getPropertyValue('${property}');

    if (result != null) return result;

    result = e.style.getPropertyValue('${Polly.browserInfo.vendorPrefix}${property}');

    return (result != null) ? result : null;
  }


  /**
   * Sets the flex [Orientation] of a flex box. */
  static void setFlexBoxOrientation(FrameworkElement element,
                                    Orientation orientation){

    final flexModel = FlexModel.getFlexModel(element.parent);

    if (flexModel == FlexModel.Box){
      setCSS(element.rawElement, 'box-orient',
        orientation == Orientation.vertical ? 'vertical' : 'horizontal');
    }else{
      element.rawElement.style.flexFlow =
      orientation == Orientation.vertical ? 'column' : 'row';
    }

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

    void flexBoxHandler(){
      //supporting the current flex box spec
      element
        ._manualAlignmentHandler
        .enableManualHorizontalAlignment(alignment);
    }

    void boxHandler(){
      print('cross axis horizontal box handler');
    }


    void noFlexHandler(){
      element
      ._manualAlignmentHandler
      .enableManualHorizontalAlignment(alignment);
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      case FlexModel.Box:
        boxHandler();
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

    void flexBoxHandler(){
      element
      ._manualAlignmentHandler
      .enableManualVerticalAlignment(alignment);
    }


    void boxHandler(){
      print('cross axis vertical box handler');
    }

    void noFlexHandler(){
      element
      ._manualAlignmentHandler
      .enableManualVerticalAlignment(alignment);
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      case FlexModel.Box:
        boxHandler();
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

    void boxHandler(){
      switch(alignment){
        case HorizontalAlignment.left:
          setCSS(element.rawElement, 'box-align', 'start');
          break;
        case HorizontalAlignment.right:
          setCSS(element.rawElement, 'box-align', 'end');
          break;
        case HorizontalAlignment.center:
          setCSS(element.rawElement, 'box-align', 'center');
          break;
        case HorizontalAlignment.stretch:
          setCSS(element.rawElement, 'box-align', 'stretch');
          break;
      }
    }

    void noFlexHandler(){
      print('called noFlexHandler()');
     // throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      case FlexModel.Box:
        boxHandler();
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

    void boxHandler(){
      switch(alignment){
        case VerticalAlignment.top:
          setCSS(element.rawElement, 'box-align', 'start');
          break;
        case VerticalAlignment.bottom:
          setCSS(element.rawElement, 'box-align', 'end');
          break;
        case VerticalAlignment.center:
          setCSS(element.rawElement, 'box-align', 'center');
          break;
        case VerticalAlignment.stretch:
          setCSS(element.rawElement, 'box-align', 'stretch');
          break;
      }
    }

    void noFlexHandler(){
      print('horizontal called noFlexHandler()');
     // throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(flexModel){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      case FlexModel.Box:
        boxHandler();
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
        Polly.setCSS(element.rawElement, 'flex', 'none');

        if(element.hAlign == HorizontalAlignment.stretch){
          Polly.setCSS(element.rawElement, 'flex', '1 1 auto');
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
          element
            ._manualAlignmentHandler
            .enableManualHorizontalAlignment(HorizontalAlignment.stretch);
        }else{
          //something else besides stretch
          element._manualAlignmentHandler.disableManualHorizontalAlignment();

          setHorizontalFlexBoxAlignment(element.parent, element.hAlign,
            FlexModel.FlexBox);
        }
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent, element.vAlign,
          FlexModel.FlexBox);
      }
    }

    void boxHandler(){
      if (element.hAlign != null){
        setHorizontalFlexBoxAlignment(element.parent, element.hAlign,
          FlexModel.Box);
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent, element.vAlign,
          FlexModel.Box);
      }
    }

    void noFlexHandler(){
      // TODO: handle all flex layouts manually...
      print('called noFlexHandler()');
   //   throw const NotImplementedException('Flex box model not yet supported.');
    }

    switch(FlexModel.getFlexModel(element.parent)){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      case FlexModel.Box:
        boxHandler();
        break;
      default:
        noFlexHandler();
    }
  }
}


