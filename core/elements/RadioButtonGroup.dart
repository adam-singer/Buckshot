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
      throw const FrameworkException("RadioButton already exists in the RadioButtonGroup list.");
    }
    
    if (!_radioButtonList.isEmpty()){
      //do a check to ensure groupName is the same
      String name = _radioButtonList.getKeys().iterator().next().groupName;
      if (name != buttonToAdd.groupName)
        throw new FrameworkException("Attempted to add RadioButton with groupName='${buttonToAdd.groupName}' to RadioButtonGroup with groupName='$name'");
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
