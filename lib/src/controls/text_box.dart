// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A basic single line TextBox.  Supports most forms of Html5 textual input type (see [InputTypes]) */
class TextBox extends Control
{
  FrameworkProperty textProperty;
  FrameworkProperty inputTypeProperty;
  FrameworkProperty placeholderProperty;
  FrameworkProperty borderColorProperty;
  FrameworkProperty backgroundProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty cornerRadiusProperty;
  FrameworkProperty borderStyleProperty;
  FrameworkProperty paddingProperty;
  FrameworkProperty foregroundProperty;
  FrameworkProperty fontSizeProperty;
  FrameworkProperty fontFamilyProperty;

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
    final _ie = rawElement as InputElement;

    placeholderProperty = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        rawElement.attributes["placeholder"] = '$value';
      });


    textProperty = new FrameworkProperty(this, "text", (value){
      _ie.value = '$value';
    },"");

    inputTypeProperty = new FrameworkProperty(this, "inputType", (InputTypes value){
      if (InputTypes._isValidInputType(value)){
        rawElement.attributes["type"] = value.toString();
      }else{
        throw new BuckshotException("Invalid input '${value}' type passed to"
        " TextBox.inputType. Use InputTypes.{type} for safe assignment.");
      }
    }, InputTypes.text, converter:const StringToInputTypesConverter());

    backgroundProperty = new AnimatingFrameworkProperty(
      this,
      "background",
      'background',
      propertyChangedCallback:(Brush value){
        if (value == null){
          rawElement.style.background = "None";
          return;
        }
        value.renderBrush(rawElement);
      },
      defaultValue: new SolidColorBrush(new Color.hex(getResource('theme_textbox_background'))),
      converter:const StringToSolidColorBrushConverter());

    borderStyleProperty = new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: (BorderStyle value){
          rawElement.style.borderStyle = '$value';
        },
        defaultValue:
          const StringToBorderStyleConverter()
                  .convert(getResource('theme_textbox_border_style')),
        converter: const StringToBorderStyleConverter());

    cornerRadiusProperty = new AnimatingFrameworkProperty(
      this,
      "cornerRadius",
      'border-radius',
      propertyChangedCallback:(Thickness value){
        // TODO (John) this is a temprorary fix until value converters are working in
        // templates...
        if (value is num){
          value = new Thickness(value);
        }

        rawElement.style.borderRadius = '${value.top}px ${value.right}px'
          ' ${value.bottom}px ${value.left}px';
      },
      defaultValue: const StringToThicknessConverter().convert(getResource('theme_textbox_corner_radius')),
      converter:const StringToThicknessConverter());

    borderColorProperty = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      'border',
      propertyChangedCallback: (Color c){
        rawElement.style.borderColor = c.toColorString();
      },
      defaultValue: new Color.hex(getResource('theme_textbox_border_color')),
      converter:const StringToColorConverter());


    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      (value){

        String color = borderColor != null
            ? rawElement.style.borderColor
            : new Color.hex(getResource('theme_textbox_border_color'));

        rawElement.style.borderTop = '${borderStyle} ${value.top}px $color';
        rawElement.style.borderRight = '${borderStyle} ${value.right}px $color';
        rawElement.style.borderLeft = '${borderStyle} ${value.left}px $color';
        rawElement.style.borderBottom = '${borderStyle} ${value.bottom}px $color';

      },
      defaultValue: const StringToThicknessConverter().convert(getResource('theme_textbox_border_thickness')),
      converter:const StringToThicknessConverter());

    paddingProperty = new FrameworkProperty(
        this,
        "padding",
        (Thickness value){
          rawElement.style.padding = '${value.top}px ${value.right}px ${value.bottom}px ${value.left}px';
          updateLayout();
        },
        defaultValue: const StringToThicknessConverter().convert(getResource('theme_textbox_padding'))
        , converter:const StringToThicknessConverter());

    foregroundProperty = new FrameworkProperty(
        this,
        "foreground",
        (Color c){
          rawElement.style.color = c.toColorString();
        },
        defaultValue: new Color.hex(getResource('theme_text_foreground')),
        converter:const StringToColorConverter());

    fontSizeProperty = new FrameworkProperty(
      this,
      "fontSize",
      (value){
        rawElement.style.fontSize = '${value.toString()}px';
      });

    fontFamilyProperty = new FrameworkProperty(
      this,
      "fontFamily",
      (value){
        rawElement.style.fontFamily = value.toString();
      }, defaultValue:getResource('theme_text_font_family'));
  }


  void _initEvents(){
    final _ie = rawElement as InputElement;
    _ie.on.keyUp.add((e){
      if (text == _ie.value) return; //no change from previous keystroke

      String oldValue = text;
      text = _ie.value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text));

      if (e.cancelable) e.cancelBubble = true;
    });

    _ie.on.change.add((e){
      if (text == _ie.value) return; //no change from previous keystroke

      String oldValue = text;
      text = _ie.value;

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

  /// Sets the [cornerRadiusProperty] value.
  set cornerRadius(int value) => setValue(cornerRadiusProperty, value);
  /// Gets the [cornerRadiusProperty] value.
  int get cornerRadius => getValue(cornerRadiusProperty);

  /// Sets the [borderColorProperty] value.
  set borderColor(Color value) => setValue(borderColorProperty, value);
  /// Gets the [borderColorProperty] value.
  Color get borderColor => getValue(borderColorProperty);

  /// Sets the [borderThicknessProperty] value.
  set borderThickness(Thickness value) => setValue(borderThicknessProperty, value);
  /// Gets the [borderThicknessProperty] value.
  Thickness get borderThickness => getValue(borderThicknessProperty);

  set borderStyle(BorderStyle value) => setValue(borderStyleProperty, value);
  BorderStyle get borderStyle => getValue(borderStyleProperty);

  /// Sets the [backgroundProperty] value.
  set background(Brush value) => setValue(backgroundProperty, value);
  /// Gets the [backgroundProperty] value.
  Brush get background => getValue(backgroundProperty);

  /// Sets the [paddingProperty] value.
  set padding(Thickness value) => setValue(paddingProperty, value);
  /// Gets the [paddingProperty] value.
  Thickness get padding => getValue(paddingProperty);

  /// Sets [fontFamilyProperty] with the given [value]
  set fontFamily(String value) => setValue(fontFamilyProperty, value);
  /// Gets the current value of [fontFamilyProperty]
  String get fontFamily => getValue(fontFamilyProperty);

  /// Sets [fontSizeProperty] with the given [value]
  set fontSize(num value) => setValue(fontSizeProperty, value);
  /// Gets the value of [fontSizeProperty]
  num get fontSize => getValue(fontSizeProperty);

  set foreground(SolidColorBrush value) => setValue(foregroundProperty, value);
  SolidColorBrush get foreground => getValue(foregroundProperty);


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
