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

class _BorderContainer extends _VirtualContainer {

  static final String parentErrorMessage = "BorderContainer parent must be of type Border.";
  
  _BorderContainer()
  {
    _Dom.appendClass(_component, "luca_ui_bordercontainer");
   horizontalAlignment = HorizontalAlignment.stretch;
   verticalAlignment = VerticalAlignment.stretch;
  }
  
  //enforce parental relationship
  set parent(FrameworkElement value) {
    if (!(value is Border))
      throw const FrameworkException(parentErrorMessage);
    
    _parent = value;
  }  
  
  set content(FrameworkElement element) {
    if (_content != null){
            
      _content._component.remove();
      _content._containerParent = null;
      _unRegisterChild(_content);
    }

    if (element != null)
    {  
        _content = element;
   
        _content._containerParent = this;
        _registerChild(_content);
        _component.nodes.add(content._component);
               
        updateLayout();
    }else{
      _content = null;
    }
  }
  
  void CreateElement(){
    super.CreateElement();
    _component.style.display = "table-cell"; //, null);
  }
  
  
  void updateLayout(){
    if (content == null || !_isLoaded) return;
    
    _Dom.setHorizontalFlexBoxAlignment(this, content.horizontalAlignment);
    _Dom.setVerticalFlexBoxAlignment(this, content.verticalAlignment);
  }
  
  String get type() => "BorderContainer";
}
