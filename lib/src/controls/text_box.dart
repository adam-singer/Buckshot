// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A basic single line TextBox.  Supports most forms of Html5 textual input type (see [InputTypes]) */
class TextBox extends Control
{
  FrameworkProperty textProperty, inputTypeProperty, placeholderProperty;
  final FrameworkEvent<TextChangedEventArgs> textChanged;

  TextBox() :
  textChanged = new FrameworkEvent<TextChangedEventArgs>()
  {
    Browser.appendClass(rawElement, "textbox");

    _initTextBoxProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;

    _initEvents();
    
    registerEvent('textchanged', textChanged);
  }
  
  TextBox.register() : super.register(),
   textChanged = new FrameworkEvent<TextChangedEventArgs>();
  makeMe() => new TextBox();

  void _initTextBoxProperties(){

    placeholderProperty = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        rawElement.attributes["placeholder"] = value;
      });


    textProperty = new FrameworkProperty(this, "text", (String value){
      rawElement.dynamic.value = value;
    },"");

    inputTypeProperty = new FrameworkProperty(this, "inputType", (InputTypes value){
      if (InputTypes._isValidInputType(value)){
        rawElement.attributes["type"] = value.toString();
      }else{
        throw new BuckshotException("Invalid input '${value}' type passed to"
        " TextBox.inputType. Use InputTypes.{type} for safe assignment.");
      }
    }, InputTypes.text, converter:const StringToInputTypesConverter());
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
  String get text => getValue(textProperty);
  set text(String value) => setValue(textProperty, value);

  InputTypes get inputType => getValue(inputTypeProperty);
  set inputType(InputTypes value) => setValue(inputTypeProperty, value);

  set placeholder(String value) => setValue(placeholderProperty, value);
  String get placeholder => getValue(placeholderProperty);


  void createElement(){
    rawElement = new InputElement();
    rawElement.attributes["type"] = "text";
  }
}

class InputTypes{
  final String _str;
  const InputTypes(this._str);

  static const password = const InputTypes("password");
  static const email = const InputTypes("email");
  static const date = const InputTypes("date");
  static const datetime = const InputTypes("datetime");
  static const month = const InputTypes("month");
  static const search = const InputTypes("search");
  static const telephone = const InputTypes("tel");
  static const text = const InputTypes("text");
  static const time = const InputTypes("time");
  static const url = const InputTypes("url");
  static const week = const InputTypes("week");

  static const List<InputTypes> validInputTypes = const <InputTypes>[password, email, date, datetime, month, search, telephone, text, time, url, week];

  static bool _isValidInputType(InputTypes candidate){
    return validInputTypes.indexOf(candidate, 0) > -1;
  }

  String toString() => _str;
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

  FrameworkProperty get textProperty;

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

    List<String> value = AttachedFrameworkProperty.getValue(element, validationProperty);

    if (Validation.validationProperty == null || value == null)
      setValidation(element, new List<String>());

    return AttachedFrameworkProperty.getValue(element, validationProperty);
  }




}
