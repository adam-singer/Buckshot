// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* An element that renders some [text].
*/
class TextBlock extends FrameworkElement implements IFrameworkContainer
{
  FrameworkProperty
    backgroundProperty,
    foregroundProperty,
    paddingProperty,
    textProperty,
    fontSizeProperty,
    fontFamilyProperty;

  TextBlock()
  {
    Browser.appendClass(rawElement, "textblock");

    _initTextBlockProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;

  }

  TextBlock.register() : super.register();
  makeMe() => new TextBlock();

  get content => getValue(textProperty);

  void _initTextBlockProperties(){

    backgroundProperty = new FrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          rawElement.style.background = "None";
          return;
        }
        value.renderBrush(rawElement);
      }, converter:const StringToSolidColorBrushConverter());

    foregroundProperty = new FrameworkProperty(
      this,
      "foreground",
      (Color c){
         rawElement.style.color = c.toColorString();
      },
      defaultValue: new Color.hex(getResource('theme_text_foreground')),
      converter:const StringToColorConverter());

    textProperty = new FrameworkProperty(
      this,
      "text",
      (value){
        rawElement.text = "$value";
      });

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

  set background(Brush value) => setValue(backgroundProperty, value);
  Brush get background => getValue(backgroundProperty);

  set text(String value) => setValue(textProperty, value);
  String get text => getValue(textProperty);

  void createElement(){
    rawElement = new ParagraphElement();
  }
}
