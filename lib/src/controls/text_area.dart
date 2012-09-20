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
  
  TextArea() :
  textChanged = new FrameworkEvent<TextChangedEventArgs>()
  {
    Browser.appendClass(rawElement, "textarea");

    _initProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;

    _initEvents();
    
    registerEvent('textchanged', textChanged);
  }
  
  TextArea.register() : super.register(),
    textChanged = new FrameworkEvent<TextChangedEventArgs>();
  makeMe() => new TextArea();

  void _initProperties(){

    placeholderProperty = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        (rawElement as TextAreaElement).attributes["placeholder"] = value;
      });


    textProperty = new FrameworkProperty(this, "text", (String value){
      (rawElement as TextAreaElement).value = value;
    },"");

    spellcheckProperty = new FrameworkProperty(this, "spellcheck", (bool value){
      (rawElement as TextAreaElement).attributes["spellcheck"] = value.toString();
    }, converter:const StringToBooleanConverter());
  }


  void _initEvents(){

    (rawElement as TextAreaElement).on.keyUp.add((e){
      if (text == (rawElement as TextAreaElement).value) return; //no change from previous keystroke

      String oldValue = text;
      text = (rawElement as TextAreaElement).value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text));

      if (e.cancelable) e.cancelBubble = true;
    });

    (rawElement as TextAreaElement).on.change.add((e){
      if (text == (rawElement as TextAreaElement).value) return; //no change from previous keystroke

      String oldValue = text;
      text = (rawElement as TextAreaElement).value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text));

      if (e.cancelable) e.cancelBubble = true;
    });

  }

  //framework property exposure
  String get text => getValue(textProperty);
  set text(String value) => setValue(textProperty, value);

  set placeholder(String value) => setValue(placeholderProperty, value);
  String get placeholder => getValue(placeholderProperty);


  void createElement(){
    rawElement = new TextAreaElement();
  }
}
