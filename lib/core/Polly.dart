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

  static void setFlexBoxOrientation(Element element, Orientation orientation){
    setXPCSS(element, 'flex-direction', (orientation == Orientation.horizontal) ? 'row' : 'column');
  }
  
  
  /// For individual items within a flexbox, but only in the cross-axis.
  static void setHorizontalItemFlexAlignment(Element element, HorizontalAlignment alignment){
    switch(alignment){
      case HorizontalAlignment.left:
        Polly.setXPCSS(element, 'align-self', 'flex-start');
        break;
      case HorizontalAlignment.right:
        Polly.setXPCSS(element, 'align-self', 'flex-end');
        break;
      case HorizontalAlignment.center:
        Polly.setXPCSS(element, 'align-self', 'center');
        break;
      case HorizontalAlignment.stretch:
        Polly.setXPCSS(element, 'align-self', 'stretch');
        break;
      }
  }

  /// For individual items within a flexbox, but only in the cross-axis.
  static void setVerticalItemFlexAlignment(Element element, VerticalAlignment alignment){
    switch(alignment){
      case VerticalAlignment.top:
        Polly.setXPCSS(element, 'align-self', 'flex-start');
        break;
      case VerticalAlignment.bottom:
        Polly.setXPCSS(element, 'align-self', 'flex-end');
        break;
      case VerticalAlignment.center:
        Polly.setXPCSS(element, 'align-self', 'center');
        break;
      case VerticalAlignment.stretch:
        Polly.setXPCSS(element, 'align-self', 'stretch');
        break;
      }
  }

  static void setHorizontalFlexBoxAlignment(Element element, HorizontalAlignment alignment, [FlexModel flexModel = FlexModel.Flex]){
    switch(flexModel){
      case FlexModel.Flex:
        switch(alignment){
          case HorizontalAlignment.left:
            setXPCSS(element, 'justify-content', 'flex-start');
            break;
          case HorizontalAlignment.right:
            setXPCSS(element, 'justify-content', 'flex-end');
            break;
          case HorizontalAlignment.center:
            setXPCSS(element, 'justify-content', 'center');
            break;
          case HorizontalAlignment.stretch:
            setXPCSS(element, 'justify-content', 'stretch');
            break;
          }
        break;
      case FlexModel.FlexBox:
        switch(alignment){
          case HorizontalAlignment.left:
            element.style.flexPack = 'start';
            break;
          case HorizontalAlignment.right:
            element.style.flexPack = 'end';
            break;
          case HorizontalAlignment.center:
            element.style.flexPack = 'center';
            break;
          case HorizontalAlignment.stretch:
            element.style.flexPack = 'start';
            break;
        }
        break;
      default:
        throw const NotImplementedException();
    }
  }

  static void setVerticalFlexBoxAlignment(Element element, VerticalAlignment alignment, [FlexModel flexModel = FlexModel.Flex]){
    switch(flexModel){
      case FlexModel.Flex:
        switch(alignment){
          case VerticalAlignment.top:
            setXPCSS(element, 'align-items', 'flex-start');
            break;
          case VerticalAlignment.bottom:
            setXPCSS(element, 'align-items', 'flex-end');
            break;
          case VerticalAlignment.center:
            setXPCSS(element, 'align-items', 'center');
            break;
          case VerticalAlignment.stretch:
            setXPCSS(element, 'align-items', 'stretch');
            break;
        }
        break;
      case FlexModel.FlexBox:
          switch(alignment){
            case VerticalAlignment.top:
              element.style.flexAlign = 'start';
              break;
            case VerticalAlignment.bottom:
              element.style.flexAlign = 'end';
              break;
            case VerticalAlignment.center:
              element.style.flexAlign = 'center';
              break;
            case VerticalAlignment.stretch:
              element.style.flexAlign = 'stretch';
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
        
        setHorizontalFlexBoxAlignment(element.parent.rawElement, element.hAlign, FlexModel.Flex);
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent.rawElement, element.vAlign, FlexModel.Flex);
      }
    }
    
    void flexBoxHandler(){
      //browser supports the older flexbox spec
      if (element.hAlign != null){
        if (element.hAlign == HorizontalAlignment.stretch){
          element.stateBag['__WIDTH_SHIM__'] = element.rawElement.style.width;
          if (element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] == null){
            element.stateBag['__MEASUREMENT_CHANGED_EVENT_REF__'] = element.parent.measurementChanged + (source, MeasurementChangedEventArgs args){
              if (element is! Border){
                //TODO: query on the paddingProperty existence instead of checking the element type
                element.rawElement.style.width = 
                    '${args.newMeasurement.client.width - (element.margin.left + element.margin.right + ((element.parent is Border) ? element.parent.dynamic.padding.left + element.parent.dynamic.padding.right : 0))}px';
              }else{
                element.rawElement.style.width = 
                    '${args.newMeasurement.client.width - (element.dynamic.padding.left + element.dynamic.padding.right + element.margin.left + element.margin.right + ((element.parent is Border) ? element.parent.dynamic.padding.left + element.parent.dynamic.padding.right : 0))}px';
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
          
          setHorizontalFlexBoxAlignment(element.parent.rawElement, element.hAlign, FlexModel.FlexBox);
        }
      }

      if (element.vAlign != null){
        setVerticalFlexBoxAlignment(element.parent.rawElement, element.vAlign, FlexModel.FlexBox);    
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
    }else if (Polly.getXPCSS(element.rawElement, 'display') == 'box' || Polly.getXPCSS(element.parent.rawElement, 'display').endsWith('-box')){
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
