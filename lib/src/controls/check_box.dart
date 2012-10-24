part of core_buckshotui_org;

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
  FrameworkProperty<String> value;
  /// Represents the groupName of the checkbox.
  FrameworkProperty<String> groupName;

  /// Event which fires whenever a selection change occurs on this checkbox.
  final FrameworkEvent selectionChanged = new FrameworkEvent<EventArgs>();

  CheckBox()
  {
    Browser.appendClass(rawElement, 'checkbox');
    _initProperties();
    _initEvents();

    registerEvent('selectionchanged', selectionChanged);
  }

  CheckBox.register() : super.register();
  makeMe() => new CheckBox();

  void _initProperties(){
    value = new FrameworkProperty(this, 'value', (String v){
      rawElement.attributes['value'] = v;
    });

    groupName = new FrameworkProperty(this, 'groupName', (String v){
      rawElement.attributes['name'] = v;
    }, 'default');
  }

  void _initEvents(){
    click + (_, __){
      selectionChanged.invoke(this, new EventArgs());
    };
  }

  /// Gets whether the check box is checked.
  bool get isChecked {
    InputElement inputElement = rawElement as InputElement;

    return inputElement.checked;
  }

  void createElement(){
    rawElement = new InputElement();
    rawElement.attributes['type'] = 'checkbox';
  }

  /// Manually sets this checkbox as the selected one of a group.
  void setAsSelected(){
    InputElement inputElement = rawElement as InputElement;

    inputElement.checked = true;
    selectionChanged.invoke(this, new EventArgs());
  }

  get defaultControlTemplate => '';
}
