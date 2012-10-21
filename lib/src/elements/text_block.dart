// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
* An element that renders some [text].
*/
class TextBlock extends FrameworkElement implements FrameworkContainer
{
  FrameworkProperty<Brush> background;
  FrameworkProperty<Color> foreground;
  FrameworkProperty<String> text;
  FrameworkProperty<num> fontSize;
  FrameworkProperty<String> fontFamily;

  //TODO: make strongly typed versions
  FrameworkProperty<String> decoration;
  FrameworkProperty<String> fontWeight;

  TextBlock()
  {
    Browser.appendClass(rawElement, "textblock");

    _initTextBlockProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = text;

    userSelect.value = true;
  }

  TextBlock.register() : super.register();
  makeMe() => new TextBlock();

  get containerContent => text.value;

  void _initTextBlockProperties(){

    fontWeight = new FrameworkProperty(this, 'fontWeight',
      (String value){
        rawElement.style.fontWeight = '$value';
      });

    decoration = new FrameworkProperty(this, 'decoration',
      propertyChangedCallback:
        (String value){
          rawElement.style.textDecoration = '$value';
        });

    background = new FrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          rawElement.style.background = "None";
          return;
        }
        value.renderBrush(rawElement);
      }, converter:const StringToSolidColorBrushConverter());

    foreground = new FrameworkProperty(
      this,
      "foreground",
      (Color c){
         rawElement.style.color = c.toColorString();
      },
      defaultValue: getResource('theme_text_foreground'),
      converter:const StringToColorConverter());

    text = new FrameworkProperty(
      this,
      "text",
      (String value){
        rawElement.text = "$value";
      });

    fontSize = new FrameworkProperty(
      this,
      "fontSize",
      (value){
        rawElement.style.fontSize = '${value.toString()}px';
      });

    fontFamily = new FrameworkProperty(
      this,
      "fontFamily",
      (value){
        rawElement.style.fontFamily = value.toString();
      }, defaultValue:getResource('theme_text_font_family'));
  }

  void createElement(){
    rawElement = new ParagraphElement();
  }
}
