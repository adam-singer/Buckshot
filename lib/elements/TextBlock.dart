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
* An element that renders some [text].
*/
class TextBlock extends FrameworkElement
{
  FrameworkProperty backgroundProperty, foregroundProperty, paddingProperty, textProperty, fontSizeProperty, fontFamilyProperty;

  FrameworkObject makeMe() => new TextBlock();

  TextBlock()
  {
    _Dom.appendBuckshotClass(_component, "textblock");

    _initTextBlockProperties();

    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = textProperty;
  }

  void _initTextBlockProperties(){

    backgroundProperty = new FrameworkProperty(
      this,
      "background",
      (Brush value){
        if (value == null){
          _component.style.background = "None";
          return;
        }
        value.renderBrush(_component);
      }, converter:const StringToSolidColorBrushConverter());

    foregroundProperty = new FrameworkProperty(
      this,
      "foreground",
      (value){
        _component.style.color = value.color.toString();
      }, new SolidColorBrush(new Color.predefined(Colors.Black)), converter:const StringToSolidColorBrushConverter());

    textProperty = new FrameworkProperty(
      this,
      "text",
      (value){
        _component.text = "$value";
      });

    fontSizeProperty = new FrameworkProperty(
      this,
      "fontSize",
      (value){
        _component.style.fontSize = '${value.toString()}px';
      });

    fontFamilyProperty = new FrameworkProperty(
      this,
      "fontFamily",
      (value){
        _component.style.fontFamily = value.toString();
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

  void CreateElement(){
    _component = new ParagraphElement();
  }

  void updateLayout(){

  }

  String get type() => "TextBlock";
}
