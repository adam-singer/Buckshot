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
* An element that renders a browser link.
*/
class Hyperlink extends FrameworkElement implements IFrameworkContainer
{
  Dynamic _content;
  
  /// Represents the content of the hyperlink.
  FrameworkProperty contentProperty;
  /// Represents the html 'target' value of the hyperlink.
  FrameworkProperty targetNameProperty;
  /// Represents the url navigation target of the hyperlink.
  FrameworkProperty navigateToProperty;
  /// Represents the foreground [Color] of a textual hyperlink.
  FrameworkProperty foregroundProperty;
  /// Represents the font size of a textual hyperlink.
  FrameworkProperty fontSizeProperty;
  /// Represents the font family value of a textual hyperlink.
  FrameworkProperty fontFamilyProperty;
  
  /// Overridden [LucaObject] method.
  FrameworkObject makeMe() => new Hyperlink();
  
  Hyperlink()
  {
    _Dom.appendClass(_component, "luca_ui_hyperlink");

    _initHyperlinkProperties();
    
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }
  
  /// Gets the [navigateToProperty] value.
  String get navigateTo() => getValue(navigateToProperty);
  /// Sets the [navigateToProperty] value.
  set navigateTo(String value) => setValue(navigateToProperty, value);
  
  /// Gets the [targetNameProperty] value.
  String get targetName() => getValue(targetNameProperty);
  /// Sets the [targetNameProperty] value.
  set targetName(String value) => setValue(targetNameProperty, value);
  
  /// Gets the [contentProperty] value.
  Dynamic get content() => getValue(contentProperty);
  /// Sets the [targetNameProperty] value.
  set content(Dynamic value) => setValue(contentProperty, value);
  
  /// Gets the [foregroundProperty] value.
  set foreground(SolidColorBrush value) => setValue(foregroundProperty, value);
  /// Sets the [foregroundProperty] value.
  SolidColorBrush get foreground() => getValue(foregroundProperty);

  /// Gets the [fontFamilyProperty] value.
  set fontFamily(String value) => setValue(fontFamilyProperty, value);
  /// Sets the [fontFamilyProperty] value.
  String get fontFamily() => getValue(fontFamilyProperty);
  
  /// Gets the [fontSizeProperty] value.
  set fontSize(num value) => setValue(fontSizeProperty, value);
  /// Sets the [fontSizeProperty] value.
  num get fontSize() => getValue(fontSizeProperty);
  
  void _initHyperlinkProperties(){
    // Initialize FrameworkProperty declarations.
    contentProperty = new FrameworkProperty(
      this,
      "content",
      (value) {
        
        //if the content is previously a textblock and the value is a String then just
        //replace the text property with the new string
        if (_content is TextBlock && value is String){
          _content.text = value;
          return;
        }

        _component.style.textDecoration = "none";
        
        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            var tempStr = value;
            _component.style.textDecoration = "underline";
            value = new TextBlock();
            value.text = tempStr;
        }        

        if (_content != null){
          _content._component.remove();
          _content.parent = null;
        }
        
        if (value != null){
          _content = value;
          _content.parent = this;
          _component.nodes.add(_content._component);
        }else{
          _content = null;
        }

      });
        
    targetNameProperty = new FrameworkProperty(this, "targetName", (String value){
      _component.attributes["target"] = value.toString();
    }, "_self");
    
    navigateToProperty = new FrameworkProperty(this, "navigateTo", (String value){
      _component.attributes["href"] = value.toString();
    });
    
    foregroundProperty = new FrameworkProperty(
      this,
      "foreground",
      (value){
        _component.style.color = value.color.toString();
      }, new SolidColorBrush(new Color.hex(Colors.Black.toString())));
    foregroundProperty.stringToValueConverter = const StringToSolidColorBrushConverter();
    
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
  
  /// Overridden [FrameworkObject] method.
  void CreateElement()
  {
    _component = _Dom.createByTag("a");  
  }
  
  String get type() => "Hyperlink";
}
