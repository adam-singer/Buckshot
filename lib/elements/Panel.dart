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
* A base class for all Panel-type elements.
*
* ## See Also
* * [Grid]
* * [LayoutCanvas]
* * [StackPanel]
*/
class Panel extends _ContainerElement implements IFrameworkContainer {
  /// An observable list of the child elements associated with the panel.
  final ObservableList<FrameworkElement> children;
  static final String childHasParentExceptionMessage = "Element is already child of another element.";

  /// Represents the background [Color] value of the panel.
  FrameworkProperty backgroundProperty;
    
  Panel()
  : children = new ObservableList<FrameworkElement>()
  {
    _Dom.appendClass(_component, "luca_ui_panel");
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;
    
    backgroundProperty = new FrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          _component.style.background = "None";
          return;
        }
        value.renderBrush(_component);
      });
    
    backgroundProperty.stringToValueConverter = const StringToSolidColorBrushConverter();
    
    children.listChanged + (_, args)
    {
      
      args.oldItems.forEach((item){
        item.parent = null;
      });
      
      args.newItems.forEach((item){
        if (item.parent != null){
          throw const FrameworkException(childHasParentExceptionMessage);    
        }
        item.parent = this;
      });
    };
  }
  
  // IFrameworkContainer interface
  get content() => children;
  
  /// Returns true if the given [FrameworkElement] is a child of the panel.
  bool contains(FrameworkElement newChild){
    return children.indexOf(newChild, 0) > -1;
  }
  
  /// Sets the [backgroundProperty] value.
  set background(Brush value) => setValue(backgroundProperty, value);
  /// Gets the [backgroundProperty] value.
  Brush get background() => getValue(backgroundProperty);
  
  String get type() => "Panel";
  
  /// Overridden [FrameworkObject] method.
  void CreateElement(){
    _component = _Dom.createByTag("div");
    _component.style.overflow = "hidden";
    _component.style.display = "inline-block";
  }
 
}

