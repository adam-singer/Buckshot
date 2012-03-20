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
* Provides a container that stacks child elements vertically or horizontally.
* See:
* * [Border]
* * [Grid]
* * [LayoutCanvas] */
class StackPanel extends Panel
{
  FrameworkProperty orientationProperty;
  
  //TODO convert to virtual child panels...?
  
  FrameworkObject makeMe() => new StackPanel();
  
  StackPanel()
  {
    _Dom.appendClass(_component, "luca_ui_stackpanel");
    orientationProperty = new FrameworkProperty(
      this,
      "orientation",
      (Orientation value){
        _Dom.setFlexBoxOrientation(this, value);

      },
      Orientation.vertical);
    
    orientationProperty.stringToValueConverter = new StringToOrientationConverter();
    
    //TODO create override in Panel instead of dedicated event here
    children.listChanged + _onListChanging;
  }
  
  set orientation(Orientation value) => setValue(orientationProperty, value);
  Orientation get orientation() => getValue(orientationProperty);
  
  void _onListChanging(Object _, ListChangedEventArgs args){

    if (!args.oldItems.isEmpty()){
      args.oldItems.forEach((FrameworkElement element){
        
        element.removeFromLayoutTree();
        element._containerParent = null;
      });
    }
    
    if (!args.newItems.isEmpty()){
      args.newItems.forEach((FrameworkElement element){
        element.addToLayoutTree(this);
//        _component.nodes.add(element._component);
        element._containerParent = this;
     
      });
    }
  }
  
 
  void CreateElement(){
    _component = _Dom.createByTag("div");
    _component.style.overflow = "visible";
  }
  
  void updateLayout()
  { }
  
  String get type() => "StackPanel";
}
