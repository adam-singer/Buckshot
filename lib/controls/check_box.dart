// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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
    Browser.appendClass(rawElement, "checkbox");
    _initProperties();
    _initEvents();
    
    registerEvent('selectionchanged', selectionChanged);
  }
  
  CheckBox.register() : super.register(),
    selectionChanged = new FrameworkEvent<EventArgs>();
  makeMe() => new CheckBox();

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
  String get value => getValue(valueProperty);
  /// Sets the [valueProperty] value.
  set value(String v) => setValue(valueProperty, v);

  /// Gets the [groupNameProperty] value.
  String get groupName => getValue(groupNameProperty);
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
}
