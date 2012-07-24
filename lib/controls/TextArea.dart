// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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
    Browser.appendClass(rawElement, "textarea");
    
    _initProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;
    
    _initEvents();
  }
  
  void _initProperties(){
    
    placeholderProperty = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        rawElement.attributes["placeholder"] = value;
      });
    
    
    textProperty = new FrameworkProperty(this, "text", (String value){
      rawElement.dynamic.value = value;
    },"");
    
    spellcheckProperty = new FrameworkProperty(this, "spellcheck", (bool value){
      rawElement.attributes["spellcheck"] = value.toString();
    }, converter:const StringToBooleanConverter());   
  }
  
  
  void _initEvents(){
    
    rawElement.on.keyUp.add((e){
      if (text == rawElement.dynamic.value) return; //no change from previous keystroke
      
      String oldValue = text;
      text = rawElement.dynamic.value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text));
      
      if (e.cancelable) e.cancelBubble = true;
    });
    
    rawElement.on.change.add((e){
      if (text == rawElement.dynamic.value) return; //no change from previous keystroke
      
      String oldValue = text;
      text = rawElement.dynamic.value;
      
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
    rawElement = new TextAreaElement();
  }
  
  String get type() => "TextArea";
}
