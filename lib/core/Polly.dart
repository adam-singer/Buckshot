// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.

/** 
 * Polly is the cross-browser & cross-platform rendering utility for Buckshot.
 * 
 * She be a harsh mistress, but aye, she be worth it on a cold winter's night.
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
      var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .removeProperty
      e.style.removeProperty(pre);
    }
  }

  /** 
   * Assigns a value to a property of an element that ensures cross-browser support. 
   * Supports all common browser prefixes.
   * 
   * Returns true if property was successfully applied. */
  static bool setXPCSS(Element e, String property, String value){
    prefixes.forEach((String p){
     var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .setProperty
     e.style.setProperty(pre, value, '1');
     });
    
    return getXPCSS(e, property) != null;
  }

  /** Gets a value from a given property.   Supports all common browser prefixes. */
  static String getXPCSS(Element e, String property){

    for(final String p in prefixes){
      var pre = '${p}${property}'; //assigning here because some bug won't let me pass it directly in .getProperty
      String result = e.style.getPropertyValue(pre);

      if (result != null) return result;
    }

    return null;
  }

  static void setFlexBoxOrientation(FrameworkElement element, Orientation orientation){
//    final flexModel = FlexModel.getFlexModel(element);
    element.rawElement.style.flexFlow = orientation == Orientation.vertical ? 'column' : 'row';
    
//    switch(flexModel){
//      case FlexModel.Flex:
//        setXPCSS(element.rawElement, 'flex-direction', (orientation == Orientation.horizontal) ? 'row' : 'column');
//        break;
//      case FlexModel.FlexBox:
//        
//        break;
//      default:
//        throw const NotImplementedException();
//    }

  }
  
  
  /** For individual items within a flexbox, but only in the cross-axis. */
  static void setHorizontalItemFlexAlignment(FrameworkElement element, HorizontalAlignment alignment, [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element.parent);
    }
    
    switch(flexModel){
      case FlexModel.Flex:
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
        break;
      case FlexModel.FlexBox:
        
        break;
      default:
        throw const NotImplementedException();
    }
    

  }

  /** For individual items within a flexbox, but only in the cross-axis. */
  static void setVerticalItemFlexAlignment(FrameworkElement element, VerticalAlignment alignment, [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element.parent);
    }
    
    switch(flexModel){
      case FlexModel.Flex:
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
        break;
      case FlexModel.FlexBox:
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
        break;
      default:
        throw const NotImplementedException();
      
    }
  }

  /** 
   * Sets the horizontal alignment of children within 
   * a given flex box container [element]. */
  static void setHorizontalFlexBoxAlignment(FrameworkElement element, HorizontalAlignment alignment, [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element);
    }
    
    switch(flexModel){
      case FlexModel.Flex:
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
        break;
      case FlexModel.FlexBox:
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
        break;
      default:
        throw const NotImplementedException();
    }
  }

  
  /** 
   * Sets the vertical alignment of children within 
   * a given flex box container [element]. */
  static void setVerticalFlexBoxAlignment(FrameworkElement element, VerticalAlignment alignment, [FlexModel flexModel]){
    if (flexModel == null){
      flexModel = FlexModel.getFlexModel(element);
    }
    
    switch(flexModel){
      case FlexModel.Flex:
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
        break;
      case FlexModel.FlexBox:
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
        break;
      default:
        throw const NotImplementedException();
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
      // browser supports the latest flexbox spec
      
      if (element.hAlign != null){
        Polly.setXPCSS(element.rawElement, 'flex', 'none');
        
        if(element.hAlign == HorizontalAlignment.stretch){
          Polly.setXPCSS(element.rawElement, 'flex', '1 1 auto');
        }
        
        setHorizontalFlexBoxAlignment(element.parent, element.hAlign, FlexModel.Flex);
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent, element.vAlign, FlexModel.Flex);
      }
    }
    
    void flexBoxHandler(){
      //browser supports the older flexbox spec
      if (element.hAlign != null){
        if (element.hAlign == HorizontalAlignment.stretch){
          element.stateBag['__WIDTH_SHIM__'] = element.rawElement.style.width;
          if (element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] == null){
            element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] = 
                element.parent.measurementChanged + (source, MeasurementChangedEventArgs args){
              if (!element.hasProperty('padding')){
//              if (element is! Border){
                //TODO: query on the paddingProperty existence instead of checking the element type
                element.rawElement.style.width = 
                    '${args.newMeasurement.client.width - (element.margin.left + element.margin.right + ((element.parent.hasProperty('padding')) ? element.parent.dynamic.padding.left + element.parent.dynamic.padding.right : 0))}px';
              }else{
                element.rawElement.style.width = 
                    '${args.newMeasurement.client.width - (element.dynamic.padding.left + element.dynamic.padding.right + element.margin.left + element.margin.right + ((element.parent.hasProperty('padding')) ? element.parent.dynamic.padding.left + element.parent.dynamic.padding.right : 0))}px';
              }
            };
          }
        }else{
          
          //something else besides stretch
          
          if (element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] != null){
            element.parent.measurementChanged - element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'];
            element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] = null;
            if (element.stateBag.containsKey('__WIDTH_SHIM__')){
              element.rawElement.style.width = element.stateBag['__WIDTH_SHIM__'];
            }
          }
          
          setHorizontalFlexBoxAlignment(element.parent, element.hAlign, FlexModel.FlexBox);
        }
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent, element.vAlign, FlexModel.FlexBox);    
      }
    }
    
    switch(FlexModel.getFlexModel(element.parent)){
      case FlexModel.Flex:
        flexHandler();
        break;
      case FlexModel.FlexBox:
        flexBoxHandler();
        break;
      default:
        throw const NotImplementedException();
    }
  }
}
  
/**
 * Enumerates flexbox model variations. */
class FlexModel{
  final int _val;
  static FlexModel _model;
  
  const FlexModel(this._val);
  
  /**
   * Static method that returns the correct FlexModel enum of
   * the given [element].
   */
  static FlexModel getFlexModel(FrameworkElement element){
    
    //since the model is the same for all elements cache it.
    if (_model != null) return _model;
    
    if (Polly.getXPCSS(element.rawElement, 'display') == null){
      _model = FlexModel.Unknown;
    }else if (Polly.getXPCSS(element.rawElement, 'display').endsWith('flex')){
      _model = FlexModel.Flex;
    }else if (Polly.getXPCSS(element.rawElement, 'display').endsWith('flexbox')){
      _model = FlexModel.FlexBox;
    }else if (Polly.getXPCSS(element.rawElement, 'display') == 'box' 
        || Polly.getXPCSS(element.parent.rawElement, 'display').endsWith('-box')){
      _model = FlexModel.Box;
    }else{
      _model = FlexModel.Unknown;
    }
    
    return _model;
  }
  
  static final Box = const FlexModel(1);
  static final FlexBox = const FlexModel(2);
  static final Flex = const FlexModel(3);
  static final Unknown = const FlexModel(4);
}
