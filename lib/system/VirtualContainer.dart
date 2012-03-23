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
* A content presenter helper for other controls that manage children. */
class _VirtualContainer extends _ContainerElement
{
  FrameworkElement _content;
  
  _VirtualContainer()
  {
    _Dom.appendClass(_component, "luca_ui_virtualcontainer");
  }
    
  FrameworkElement get content() => _content;
  
  set content(FrameworkElement element) {
    if (_content != null){
      
      _content.removeFromLayoutTree();
//      _content._component.remove();
      
      _content._containerParent = null;
      _unRegisterChild(_content);
    }

    if (element != null)
    {  
        _content = element;
   
        _content._containerParent = this;
        _registerChild(_content);
        //_component.nodes.add(content._component);
        content.addToLayoutTree(this); 
        
        updateLayout();
    }else{
      _content = null;
    }
  }
  
  int get innerWidth() => actualWidth;
  int get innerHeight() => actualHeight;
  
  void calculateWidth(int value){
    if (value == "auto"){
      _component.style.width = "auto";
      setValue(actualWidthProperty, innerWidth);
      return;
    }

    
    if (minWidth != null && value < minWidth){
      width = minWidth;
    }
    
    if (maxWidth != null && value > maxWidth){
      width = maxWidth;
    }

    _component.style.width = '${value.toString()}px';
    setValue(actualWidthProperty, value);
  }
  
  void calculateHeight(int value){
    if (value == "auto"){
      _component.style.height = "auto";
      setValue(actualHeightProperty, innerHeight);
      return;
    }
       
    if (minHeight != null && value < minHeight){
      height = minHeight;
    }
    
    if (maxHeight != null && value > maxHeight){
      height =  maxHeight;
    }

    _component.style.height = '${value.toString()}px'; 
    setValue(actualHeightProperty, value);
  }
  
  
  void CreateElement(){
    _component = _Dom.createByTag("div");
    _component.style.overflow = "hidden";

  }
   
  void updateLayout(){}
  
  String get _type() => "VirtualContainer";
}
