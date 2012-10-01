// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A button that only allows a single selection when part of the same group. */
class RadioButton extends Control
{
  /// Represents the value of the radio button.
  FrameworkProperty valueProperty;
  /// Represents the groupName of the radio button.
  FrameworkProperty groupNameProperty;

  /// Event which fires whenever a selection change occurs on this radio button.
  final FrameworkEvent selectionChanged;

  RadioButton()
  : selectionChanged = new FrameworkEvent<EventArgs>()
  {
    Browser.appendClass(rawElement, 'radiobutton');
    _initProperties();
    _initEvents();

    registerEvent('selectionchanged', selectionChanged);
  }

  RadioButton.register() : super.register(),
    selectionChanged = new FrameworkEvent<EventArgs>();
  makeMe() => new RadioButton();

  void _initProperties(){
    valueProperty = new FrameworkProperty(this, 'value', (String v){
      rawElement.attributes['value'] = v;
    });

    groupNameProperty = new FrameworkProperty(this, 'groupName', (String v){
      rawElement.attributes['name'] =  v;
    }, 'default');
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
}
