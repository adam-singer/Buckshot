part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A button that only allows a single selection when part of the same group. */
class RadioButton extends Control
{
  /// Represents the value of the radio button.
  FrameworkProperty<String> value;
  /// Represents the groupName of the radio button.
  FrameworkProperty<String> groupName;

  /// Event which fires whenever a selection change occurs on this radio button.
  final FrameworkEvent selectionChanged = new FrameworkEvent<EventArgs>();

  RadioButton()
  {
    Browser.appendClass(rawElement, 'radiobutton');
    _initProperties();
    _initEvents();

    registerEvent('selectionchanged', selectionChanged);
  }

  RadioButton.register() : super.register();
  makeMe() => new RadioButton();

  void _initProperties(){
    value = new FrameworkProperty(this, 'value', (String v){
      rawElement.attributes['value'] = v;
    });

    groupName = new FrameworkProperty(this, 'groupName', (String v){
      rawElement.attributes['name'] =  v;
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
    rawElement.attributes['type'] = 'radio';
  }

  /// Manually sets this radio button as the selected one of a group.
  void setAsSelected(){
    InputElement inputElement = rawElement as InputElement;

    inputElement.checked = true;
    selectionChanged.invoke(this, new EventArgs());
  }

  get defaultControlTemplate => '';
}
