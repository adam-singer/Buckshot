part of core_buckshotui_org;

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
  final FrameworkEvent<TextChangedEventArgs> textChanged =
      new FrameworkEvent<TextChangedEventArgs>();

  FrameworkProperty<String> text;
  FrameworkProperty<String> placeholder;
  FrameworkProperty<bool> spellcheck;
  FrameworkProperty<Color> borderColor;
  FrameworkProperty<Brush> background;
  FrameworkProperty<Thickness> borderThickness;
  FrameworkProperty<Thickness> cornerRadius;
  FrameworkProperty<BorderStyle> borderStyle;
  FrameworkProperty<num> padding;
  FrameworkProperty<Color> foreground;
  FrameworkProperty<num> fontSize;
  FrameworkProperty<String> fontFamily;

  TextArea(){
    Browser.appendClass(rawElement, "textarea");

    _initProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = text;

    _initEvents();

    registerEvent('textchanged', textChanged);

    userSelect.value = true;
  }

  TextArea.register() : super.register();
  makeMe() => new TextArea();

  void _initProperties(){

    placeholder = new FrameworkProperty(
      this,
      "placeholder",
      (String value){
        (rawElement as TextAreaElement).attributes["placeholder"] = value;
      });


    text = new FrameworkProperty(this, "text", (String value){
      (rawElement as TextAreaElement).value = value;
    },"");

    spellcheck= new FrameworkProperty(this, "spellcheck", (bool value){
      (rawElement as TextAreaElement).attributes["spellcheck"] = value.toString();
    }, converter:const StringToBooleanConverter());

    background = new AnimatingFrameworkProperty(
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

    borderStyle = new FrameworkProperty(this, 'borderStyle',
        propertyChangedCallback: (BorderStyle value){
          rawElement.style.borderStyle = '$value';
        },
        defaultValue:
          getResource('theme_textarea_border_style',
                      const StringToBorderStyleConverter()),
        converter: const StringToBorderStyleConverter());

    cornerRadius = new AnimatingFrameworkProperty(
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

    borderColor= new AnimatingFrameworkProperty(
      this,
      "borderColor",
      'border',
      propertyChangedCallback: (Color c){
        rawElement.style.borderColor = c.toColorString();
      },
      defaultValue: getResource('theme_textarea_border_color'),
      converter:const StringToColorConverter());


    borderThickness = new FrameworkProperty(
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

    padding = new FrameworkProperty(
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

    foreground = new FrameworkProperty(
        this,
        "foreground",
        (Color c){
          rawElement.style.color = c.toColorString();
        },
        defaultValue: getResource('theme_textarea_foreground'),
        converter:const StringToColorConverter());

    fontSize = new FrameworkProperty(
      this,
      "fontSize",
      (value){
        rawElement.style.fontSize = '${value}px';
      });

    fontFamily = new FrameworkProperty(
      this,
      "fontFamily",
      (value){
        rawElement.style.fontFamily = '$value';
      }, defaultValue:getResource('theme_textarea_font_family'));
  }


  void _initEvents(){

    (rawElement as TextAreaElement).on.keyUp.add((e){
      if (text == (rawElement as TextAreaElement).value) return; //no change from previous keystroke

      String oldValue = text.value;
      text.value = (rawElement as TextAreaElement).value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text.value));

      if (e.cancelable) e.cancelBubble = true;
    });

    (rawElement as TextAreaElement).on.change.add((e){
      if (text.value == (rawElement as TextAreaElement).value) return; //no change from previous keystroke

      String oldValue = text.value;
      text.value = (rawElement as TextAreaElement).value;

      if (!textChanged.hasHandlers) return;
      textChanged.invoke(this, new TextChangedEventArgs.with(oldValue, text.value));

      if (e.cancelable) e.cancelBubble = true;
    });

  }

  void createElement(){
    rawElement = new TextAreaElement();
  }

  get defaultControlTemplate => '';
}
