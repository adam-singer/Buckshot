// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.

/** 
 * Polly is the cross-browser & cross-platform rendering utility for Buckshot.
 * 
 * She's a harsh mistress, but aye, she be worth it.
 */
class Polly {
  
  static BrowserInfo _browserInfo;
  
  static BrowserInfo get browserInfo() {
    if (_browserInfo != null) return _browserInfo;
    
    _browserInfo = Browser.getBrowserInfo();
    
    return _browserInfo;
  }
  
  /** 
   * Converts the root DOM element of the given [element] 
   * into a Flexbox. */
  static void makeFlexBox(FrameworkElement element){
    Browser.makeFlexBox(element.rawElement);
  }
  
  /**
   * Sets the alignment of a given [element] within it's parent 
   * [FrameworkElement].  This function assumes that the parent element
   * is already flexbox.
   */
  static void setFlexboxAlignment(FrameworkElement element){
    Browser.setXPCSS(element.rawElement, 'flex', 'none');
    
    if (element.hAlign != null){
      if(element.hAlign == HorizontalAlignment.stretch){
        Browser.setXPCSS(element.rawElement, 'flex', '1 1 auto');
      }
      
      Browser.setHorizontalFlexBoxAlignment(element.parent.rawElement, element.hAlign);
    }

    if (element.vAlign != null){
      Browser.setVerticalFlexBoxAlignment(element.parent.rawElement, element.vAlign);
    }
  }

}
