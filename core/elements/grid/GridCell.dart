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

class _GridCell extends _VirtualContainer
{ 
  static final String parentErrorMessage = "GridCell parent must be of type Grid.";
   
  
  _GridCell(){
    _Dom.appendClass(_component, "luca_ui_gridcell");
//    horizontalAlignment = HorizontalAlignment.Stretch;
//    verticalAlignment = VerticalAlignment.Stretch;
  }
  
  //enforce parental relationship
  set parent(FrameworkElement value) {
    if (!(value is Grid))
      throw const FrameworkException(parentErrorMessage);
    
    _parent = value;
  }
  
  int _getHeight(){
    if (content == null) return 0;
    
    int h = this._rawElement.getBoundingClientRect().height;
        
    if (content.verticalAlignment != VerticalAlignment.stretch) return h;

    // if the content is stretched vertically, then we need to temporarily unstretch the width and height
    // in order to measure it properly
      
    _unRegisterChild(content); //prevent extra events from firing
    
    content.height = "auto";
    content.width = "auto";
    content.updateLayout();
    h = _rawElement.clientHeight;
    _registerChild(content);
    
    content.updateLayout(); //restore the registration

    return h;
  }
  
  
  void CreateElement(){
    super.CreateElement();
    _component.style.display = "table-cell";
  }
  

  updateLayout(){
    if (content == null) return;
    _Dom.setHorizontalFlexBoxAlignment(this, content.horizontalAlignment);
    _Dom.setVerticalFlexBoxAlignment(this, content.verticalAlignment);
  }
  
  String get type() => "GridCell";
}
