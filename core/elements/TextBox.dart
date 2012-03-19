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
* A basic single line TextBox.  Supports most forms of Html5 textual input type (see [InputTypes]) */
class TextBox extends Control
{
  FrameworkProperty textProperty, inputTypeProperty, placeholderProperty;
  final FrameworkEvent<TextChangedEventArgs> textChanged;
  
  FrameworkObject makeMe() => new TextBox();
  
  TextBox() :
  textChanged = new FrameworkEvent<TextChangedEventArgs>()
  {
    _Dom.appendClass(_component, "luca_ui_textbox");
    
    _initTextBoxProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;
    
    _initEvents();
  }
  
  void _initTextBoxProperties(){
    
    placeholderProperty = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        _component.attributes["placeholder"] = value;
      });
    
    
    textProperty = new FrameworkProperty(this, "text", (String value){
      _component.dynamic.value = value;
    },"");
    
    inputTypeProperty = new FrameworkProperty(this, "inputType", (String value){
      if (InputTypes._isValidInputType(value)){
        _component.attributes["type"] = value;
      }else{
        throw new FrameworkException("Invalid input '${value}' type passed to TextBox.inputType. Use InputTypes.{type} for safe assignment.");
      }
    }, InputTypes.text);
  }
  
  
  void _initEvents(){
    
    _component.on.keyUp.add((e){
      if (text == _component.dynamic.value) return; //no change from previous keystroke
      
      String oldValue = text;
      text = _component.dynamic.value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text));
      
      if (e.cancelable) e.cancelBubble = true;
    });
    
    _component.on.change.add((e){
      if (text == _component.dynamic.value) return; //no change from previous keystroke
      
      String oldValue = text;
      text = _component.dynamic.value;
      
      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text));
      
      if (e.cancelable) e.cancelBubble = true;  
    });     

  }
  
  //framework property exposure
  String get text() => getValue(textProperty);
  set text(String value) => setValue(textProperty, value);
  
  String get inputType() => getValue(inputTypeProperty);
  set inputType(String value) => setValue(inputTypeProperty, value);
  
  set placeholder(String value) => setValue(placeholderProperty, value);
  String get placeholder() => getValue(placeholderProperty);
  
  
  void CreateElement(){
    _component = _Dom.createByTag("input");
    _component.attributes["type"] = "text";
  }
  
  String get type() => "TextBox";
}

//TODO convert to Nystrom enum pattern
class InputTypes{
  static final String password = "password";
  static final String email = "email";
  static final String date = "date";
  static final String datetime = "datetime";
  static final String month = "month";
  static final String search = "search";
  static final String telephone = "tel";
  static final String text = "text";
  static final String time = "time";
  static final String url = "url";
  static final String week = "week";
  static final List<String> _validInputTypes = const <String>[password, email, date, datetime, month, search, telephone, text, time, url, week];
  
  static bool _isValidInputType(String candidate){
    return _validInputTypes.indexOf(candidate, 0) > -1;
  }
}


class TextChangedEventArgs extends EventArgs {
  String newText;
  String oldText;
  
  TextChangedEventArgs(){}
  
  TextChangedEventArgs.with(this.oldText, this.newText);
  
}

interface IValidatable
{  
  bool isValid;
  
  FrameworkProperty get textProperty();
  
  setInvalid();
  
  void setValid();
}

/**
* Provides a validation service for IValidatable elements */
class Validation{
  static AttachedFrameworkProperty validationProperty;
  
  
  static void setValidation(FrameworkElement element, List<String> validationRules){
    if (element == null || validationRules == null) return;
    
    if (Validation.validationProperty == null){
      Validation.validationProperty = new AttachedFrameworkProperty("validation",
        (FrameworkElement e, List<String> vr){
        
      });
    }
  }
  
  static List<String> getValidation(FrameworkElement element){
    if (element == null) return null;
    
    List<String> value = FrameworkObject.getAttachedValue(element, validationProperty);
    
    if (Validation.validationProperty == null || value == null)
      setValidation(element, new List<String>());
    
    return FrameworkObject.getAttachedValue(element, validationProperty);
  }
  

}
