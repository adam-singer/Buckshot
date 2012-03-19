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
* A button that only allows a single selection when part of the same group. */
class RadioButton extends FrameworkElement
{
  FrameworkProperty valueProperty, groupNameProperty;
  
  final FrameworkEvent selectionChanged;
  
  RadioButton()
  : selectionChanged = new FrameworkEvent<EventArgs>()
  {
    _Dom.appendClass(_component, "luca_ui_radiobutton");
    _initProperties();
    _initEvents();
  }    
  
  FrameworkObject makeMe() => new RadioButton();
  
  void _initProperties(){
    
    valueProperty = new FrameworkProperty(this, "value", (String v){
      _component.attributes["value"] = v;
    });
    
    groupNameProperty = new FrameworkProperty(this, "groupName", (String v){
      _component.attributes["name"] =  v;  
    }, "default");
    
  }
  
  void _initEvents(){
    
    click + (_, __){
      selectionChanged.invoke(this, new EventArgs());
    };
  }
  
  String get value() => getValue(valueProperty);
  set value(String v) => setValue(valueProperty, v);
  
  String get groupName() => getValue(groupNameProperty);
  set groupName(String v) => setValue(groupNameProperty, v);
  
  
  void CreateElement(){
    _component = _Dom.createByTag("input");
    _component.attributes["type"] = "radio";
  }
  
  void setAsSelected(){
    _component.attributes["checked"] = "true";
    selectionChanged.invoke(this, new EventArgs());
  }
  
  String get type() => "RadioButton";
}
