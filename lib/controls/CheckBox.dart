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
* Represents a control that allows the user to select one or more of similar items.
*
* ## Lucaxml Usage Example:
*     <checkbox value="1" groupname="group1"></checkbox>
*/
class CheckBox extends Control
{
  /// Represents the value of the checkbox.
  FrameworkProperty valueProperty;
  /// Represents the groupName of the checkbox.
  FrameworkProperty groupNameProperty;
  
  /// Event which fires whenever a selection change occurs on this checkbox.
  final FrameworkEvent selectionChanged;
  
  CheckBox()
  : selectionChanged = new FrameworkEvent<EventArgs>()
  {
    Dom.appendBuckshotClass(rawElement, "checkbox");
    _initProperties();
    _initEvents();
  }    
  
  /// Overloaded [BuckshotObject] method for creating new checkboxes.
  FrameworkObject makeMe() => new CheckBox();
  
  void _initProperties(){
    
    valueProperty = new FrameworkProperty(this, "value", (String v){
      rawElement.attributes["value"] = v;
    });
    
    groupNameProperty = new FrameworkProperty(this, "groupName", (String v){
      rawElement.attributes["name"] = v;  
    }, "default");
    
  }
  
  void _initEvents(){
    click + (_, __){
      selectionChanged.invoke(this, new EventArgs());
    };
  }
  
  /// Gets the [valueProperty] value.
  String get value() => getValue(valueProperty);
  /// Sets the [valueProperty] value.
  set value(String v) => setValue(valueProperty, v);
  
  /// Gets the [groupNameProperty] value.
  String get groupName() => getValue(groupNameProperty);
  /// Sets the [groupNameProperty] value.
  set groupName(String v) => setValue(groupNameProperty, v);
  
  
  void createElement(){
    rawElement = new InputElement();
    rawElement.attributes["type"] = "checkbox";
  }
  
  /// Manually sets this checkbox as the selected one of a group.
  void setAsSelected(){
    rawElement.attributes["checked"] = "true";
    selectionChanged.invoke(this, new EventArgs());
  }
  
  String get type() => "CheckBox";
}
