// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A button that only allows a single selection when part of the same group. */
class RadioButton extends Control
{
  FrameworkProperty valueProperty, groupNameProperty;

  final FrameworkEvent selectionChanged;

  RadioButton()
  : selectionChanged = new FrameworkEvent<EventArgs>()
  {
    Browser.appendClass(rawElement, "radiobutton");
    _initProperties();
    _initEvents();
  }

  FrameworkObject makeMe() => new RadioButton();

  void _initProperties(){

    valueProperty = new FrameworkProperty(this, "value", (String v){
      rawElement.attributes["value"] = v;
    });

    groupNameProperty = new FrameworkProperty(this, "groupName", (String v){
      rawElement.attributes["name"] =  v;
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


  void createElement(){
    rawElement = new InputElement();
    rawElement.attributes["type"] = "radio";
  }

  void setAsSelected(){
    rawElement.attributes["checked"] = "true";
    selectionChanged.invoke(this, new EventArgs());
  }

  String get type() => "RadioButton";

  int _templatePriority() => 20;
}
