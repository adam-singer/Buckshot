//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* Base class for any other class that act as a container
* for one or more child [FrameworkElement]'s */
class _ContainerElement extends FrameworkElement
{
  static final String _horizontalReference = "__horizontalAlignmentEventReference__";
  static final String _verticalReference = "__verticalAlignmentEventReference__";
  Binding _horizontalBinding;
  Binding _verticalBinding;
  
  _ContainerElement(){}
  
  _registerChild(FrameworkElement child){
    if (child._containerParent == null)
      throw const FrameworkException("Child registration requires parental assignment.");
    
    //hook into the horizontal/vertical alignment property event changes
    child._stateBag[_ContainerElement._horizontalReference] = child.horizontalAlignmentProperty.propertyChanging + _onHorizontalAlignmentChanged;
    child._stateBag[_ContainerElement._verticalReference] = child.verticalAlignmentProperty.propertyChanging + _onVerticalAlignmentChanged;
    
    //update the bindings if necessary;
    _updateHorizontalAlignmentSettings(child);
    _updateVerticalAlignmentSettings(child);
  }
  
  _unRegisterChild(FrameworkElement child){   
    // unhook from the horizontal/vertical alignment property event changes 
    child.horizontalAlignmentProperty.propertyChanging - child._stateBag[_ContainerElement._horizontalReference];
    child.verticalAlignmentProperty.propertyChanging - child._stateBag[_ContainerElement._verticalReference];
    
    // undo bindings if they exist
    _clearBindings(child);
    
    // cleanup statebag references
    child._stateBag.remove(_ContainerElement._horizontalReference);
    child._stateBag.remove(_ContainerElement._verticalReference);
  }
  
  void _onHorizontalAlignmentChanged(FrameworkElement sender, PropertyChangingEventArgs args){
    _updateHorizontalAlignmentSettings(sender);
  }
  
  void _onVerticalAlignmentChanged(FrameworkElement sender, PropertyChangingEventArgs args){
    _updateVerticalAlignmentSettings(sender);
  }
    
  void _clearBindings(FrameworkElement child){
    _clearHorizontalBinding(child);
    
    _clearVerticalBinding(child);
  }
  
  void _clearHorizontalBinding(FrameworkElement child){
    if (_horizontalBinding == null) return;
    
    _horizontalBinding.unregister();
    _horizontalBinding = null;
    
    child._containerParent.updateLayout();
  }
  
  void _clearVerticalBinding(FrameworkElement child){
    if (_verticalBinding == null) return;
    
    _verticalBinding.unregister();
    _verticalBinding = null;
    
    child._containerParent.updateLayout();
  }
  
  void _setHorizontalBinding(FrameworkElement child){
    if (_horizontalBinding != null)
      throw const FrameworkException("Horizontal binding already set in _ContainerElement.");
    
    _horizontalBinding = new Binding(child._containerParent.actualWidthProperty, child.widthProperty);
  }
  
  void _setVerticalBinding(FrameworkElement child){
    if (_verticalBinding != null)
      throw const FrameworkException("Vertical binding already set in _ContainerElement.");
    
    _verticalBinding = new Binding(child._containerParent.actualHeightProperty, child.heightProperty);
  }
  
  void _updateHorizontalAlignmentSettings(FrameworkElement element){
    if (_horizontalBinding == null && element.horizontalAlignment == HorizontalAlignment.stretch){
      _setHorizontalBinding(element);
      return;
    }
    
    if (_horizontalBinding != null && element.horizontalAlignment != HorizontalAlignment.stretch){
      _clearHorizontalBinding(element);
    }
  }
  
  void _updateVerticalAlignmentSettings(FrameworkElement element){
    if (_verticalBinding == null && element.verticalAlignment == VerticalAlignment.stretch){
      _setVerticalBinding(element);
      return;
    }
    
    if (_verticalBinding != null && element.verticalAlignment != VerticalAlignment.stretch){
      _clearVerticalBinding(element);
    }
  }
  
  String get type() => "ContainerElement";
}
