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
* A button control element. 
*/
class Button extends Control implements IFrameworkContainer
{ 
  Dynamic _content;
 
  /// Represents the content inside the button.
  FrameworkProperty contentProperty;
  
  /// Overridden [LucaObject] method for creating new buttons.
  FrameworkObject makeMe() => new Button();
  
  Button()
  {
    _Dom.appendClass(_component, "luca_ui_button");
        
    // Initialize FrameworkProperty declarations.
    contentProperty = new FrameworkProperty(
      this,
      "content",
      (value) {
        
        //if the content is previously a textblock and the value is a String then just
        //replace the text property with the new string
        if (_content is TextBlock && value is String){
          _content.text = value;
          return;
        }
        
        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            var tempStr = value;
            value = new TextBlock();
            value.text = tempStr;
        }        

        if (_content != null){
          _content._component.remove();
          _content.parent = null;
        }
        
        if (value != null){
          _content = value;
          _content.parent = this;
          _component.nodes.add(_content._component);
        }else{
          _content = null;
        }

      });
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  /// Gets the [contentProperty] value.
  Dynamic get content() => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(Dynamic value) => setValue(contentProperty, value);
  
  /// Overridden [FrameworkObject] method.
  void CreateElement()
  {
    _component = _Dom.createByTag("button");   
  }
  
  String get type() => "Button";
}
