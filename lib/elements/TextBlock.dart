// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* An element that renders some [text].
*/
class TextBlock extends FrameworkElement implements IFrameworkContainer
{
  FrameworkProperty backgroundProperty, foregroundProperty, paddingProperty, textProperty, fontSizeProperty, fontFamilyProperty;

  FrameworkObject makeMe() => new TextBlock();

  TextBlock()
  {
    Browser.appendClass(rawElement, "textblock");

    _initTextBlockProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;
  }
  
  get content() => getValue(textProperty);

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
      (value){
        rawElement.style.color = value.color.toString();
      }, new SolidColorBrush(new Color.predefined(Colors.Black)), converter:const StringToSolidColorBrushConverter());

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
      });
  }

  /// Sets [fontFamilyProperty] with the given [value]
  set fontFamily(String value) => setValue(fontFamilyProperty, value);
  /// Gets the current value of [fontFamilyProperty]
  String get fontFamily() => getValue(fontFamilyProperty);

  /// Sets [fontSizeProperty] with the given [value]
  set fontSize(num value) => setValue(fontSizeProperty, value);
  /// Gets the value of [fontSizeProperty]
  num get fontSize() => getValue(fontSizeProperty);

  set foreground(SolidColorBrush value) => setValue(foregroundProperty, value);
  SolidColorBrush get foreground() => getValue(foregroundProperty);

  set background(Brush value) => setValue(backgroundProperty, value);
  Brush get background() => getValue(backgroundProperty);

  set text(String value) => setValue(textProperty, value);
  String get text() => getValue(textProperty);

  void createElement(){
    rawElement = new ParagraphElement();
  }

  void updateLayout(){

  }

  String get type() => "TextBlock";
}
