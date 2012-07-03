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
* A multi-line text box element.
* See:
* * [TextBox]
* * [TextBlock]
*/
class TextArea extends Control
{
  FrameworkProperty textProperty, placeholderProperty, spellcheckProperty;
  final FrameworkEvent<TextChangedEventArgs> textChanged;
  
  FrameworkObject makeMe() => new TextArea();
  
  TextArea() :
  textChanged = new FrameworkEvent<TextChangedEventArgs>()
  {
    Dom.appendBuckshotClass(_component, "textarea");
    
    _initProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;
    
    _initEvents();
  }
  
  void _initProperties(){
    
    placeholderProperty = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        _component.attributes["placeholder"] = value;
      });
    
    
    textProperty = new FrameworkProperty(this, "text", (String value){
      _component.dynamic.value = value;
    },"");
    
    spellcheckProperty = new FrameworkProperty(this, "spellcheck", (bool value){
      _component.attributes["spellcheck"] = value.toString();
    }, converter:const StringToBooleanConverter());   
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
   
  set placeholder(String value) => setValue(placeholderProperty, value);
  String get placeholder() => getValue(placeholderProperty);
  
  
  void createElement(){
    _component = new TextAreaElement();
  }
  
  String get type() => "TextArea";
}
