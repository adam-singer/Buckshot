// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a View definition for the framework.
* 
* (in the MVVM context of a "view") 
*
*/
class IView {
  FrameworkElement _rootElement;
  
  /// Gets the visual root of the view.
  FrameworkElement get rootVisual() => _rootElement;
  
  /// Constructs a view from a given [FrameworkElement].
  IView.from(FrameworkElement element){
    _rootElement = element;
  }
}
