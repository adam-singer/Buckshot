// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A helper class for managing a group of [RadioButton]s.  Does not itself provide any rendering
* capability. */
class RadioButtonGroup {
  final Map<RadioButton, EventHandlerReference> _radioButtonList;
  final FrameworkEvent<RadioButtonSelectionChangedEventArgs> selectionChanged;
  
  RadioButton currentSelectedButton;
  
  RadioButtonGroup(): _radioButtonList = new Map<RadioButton, EventHandlerReference>(),
  selectionChanged = new FrameworkEvent<RadioButtonSelectionChangedEventArgs>();
  
  /** Add a RadioButton to the list.  Must be of same grouping as previously added buttons */
  void addRadioButton(RadioButton buttonToAdd){
    if (buttonToAdd == null) return;
    
    if (_radioButtonList.containsKey(buttonToAdd)){
      throw const BuckshotException("RadioButton already exists in the RadioButtonGroup list.");
    }
    
    if (!_radioButtonList.isEmpty()){
      //do a check to ensure groupName is the same
      String name = _radioButtonList.getKeys().iterator().next().groupName;
      if (name != buttonToAdd.groupName)
        throw new BuckshotException("Attempted to add RadioButton with groupName='${buttonToAdd.groupName}' to RadioButtonGroup with groupName='$name'");
    }
    
    //register to the selection event of the button
    EventHandlerReference ref = buttonToAdd.selectionChanged + (button, __){
      currentSelectedButton = button;
      this.selectionChanged.invoke(this, new RadioButtonSelectionChangedEventArgs(button));
    };
    
    //add the button to the list
    _radioButtonList[buttonToAdd] = ref;
    
  }
  
  /** Remove a RadioButton from the list. */
  void removeRadioButton(RadioButton buttonToRemove){
    if (buttonToRemove == null) return;
    
    if (_radioButtonList.containsKey(buttonToRemove)){
      //remove the event reference
      buttonToRemove.selectionChanged - _radioButtonList[buttonToRemove];
      
      //remove the button
      _radioButtonList.remove(buttonToRemove);
    }
  }
}

class RadioButtonSelectionChangedEventArgs extends EventArgs{
  final RadioButton selectedRadioButton;
  
  RadioButtonSelectionChangedEventArgs(this.selectedRadioButton);
  
}
