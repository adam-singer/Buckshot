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
  final FrameworkEvent<TextChangedEventArgs> textChanged;
  FrameworkProperty textProperty;
  FrameworkProperty placeholderProperty;
  FrameworkProperty spellcheckProperty;
  FrameworkProperty borderColorProperty;
  FrameworkProperty backgroundProperty;
  FrameworkProperty borderThicknessProperty;
  FrameworkProperty cornerRadiusProperty;
  FrameworkProperty borderStyleProperty;
  FrameworkProperty paddingProperty;
  FrameworkProperty foregroundProperty;
  FrameworkProperty fontSizeProperty;
  FrameworkProperty fontFamilyProperty;

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
        defaultValue: getResource('theme_textarea_background'),
        converter:const StringToSolidColorBrushConverter());

    borderStyleProperty = new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: (BorderStyle value){
          rawElement.style.borderStyle = '$value';
        },
        defaultValue:
          getResource('theme_textarea_border_style',
                      const StringToBorderStyleConverter()),
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
      defaultValue: getResource('theme_textarea_corner_radius',
                                converter: const StringToThicknessConverter()),
      converter:const StringToThicknessConverter());

    borderColorProperty = new AnimatingFrameworkProperty(
      this,
      "borderColor",
      'border',
      propertyChangedCallback: (Color c){
        rawElement.style.borderColor = c.toColorString();
      },
      defaultValue: getResource('theme_textarea_border_color'),
      converter:const StringToColorConverter());


    borderThicknessProperty = new FrameworkProperty(
      this,
      "borderThickness",
      (value){

        String color = borderColor != null
            ? rawElement.style.borderColor
            : getResource('theme_textbox_border_color').toColorString();

        rawElement.style.borderTop = '${borderStyle} ${value.top}px $color';
        rawElement.style.borderRight = '${borderStyle} ${value.right}px $color';
        rawElement.style.borderLeft = '${borderStyle} ${value.left}px $color';
        rawElement.style.borderBottom = '${borderStyle} ${value.bottom}px $color';

      },
      defaultValue: getResource('theme_textarea_border_thickness',
                                converter:const StringToThicknessConverter()),
      converter:const StringToThicknessConverter());

    paddingProperty = new FrameworkProperty(
        this,
        "padding",
        (Thickness value){
          rawElement.style.padding = '${value.top}px ${value.right}px'
            ' ${value.bottom}px ${value.left}px';
          updateLayout();
        },
        defaultValue: getResource('theme_textarea_padding',
                                  converter: const StringToThicknessConverter())
        , converter:const StringToThicknessConverter());

    foregroundProperty = new FrameworkProperty(
        this,
        "foreground",
        (Color c){
          rawElement.style.color = c.toColorString();
        },
        defaultValue: getResource('theme_textarea_foreground'),
        converter:const StringToColorConverter());

    fontSizeProperty = new FrameworkProperty(
      this,
      "fontSize",
      (value){
        rawElement.style.fontSize = '${value}px';
      });

    fontFamilyProperty = new FrameworkProperty(
      this,
      "fontFamily",
      (value){
        rawElement.style.fontFamily = '$value';
      }, defaultValue:getResource('theme_textarea_font_family'));
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
    rawElement = new TextAreaElement();
  }
}
