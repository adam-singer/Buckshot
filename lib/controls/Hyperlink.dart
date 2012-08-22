// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* An element that renders a browser link.
*/
class Hyperlink extends Control implements IFrameworkContainer
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

  Hyperlink()
  {
    Browser.appendClass(rawElement, "hyperlink");

    _initHyperlinkProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
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

        rawElement.style.textDecoration = "none";

        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            var tempStr = value;
            rawElement.style.textDecoration = "underline";
            value = new TextBlock();
            (value as TextBlock).text = tempStr;
        }

        if (_content != null){
          _content.rawElement.remove();
          _content.parent = null;
        }

        if (value != null){
          _content = value;
          _content.parent = this;
          rawElement.nodes.add(_content.rawElement);
        }else{
          _content = null;
        }

      });

    targetNameProperty = new FrameworkProperty(this, "targetName", (String value){
      rawElement.attributes["target"] = value.toString();
    }, "_self");

    navigateToProperty = new FrameworkProperty(this, "navigateTo", (String value){
      rawElement.attributes["href"] = value.toString();
    });

    foregroundProperty = new FrameworkProperty(
      this,
      "foreground",
      (value){
        rawElement.style.color = value.color.toString();
      }, new SolidColorBrush(new Color.predefined(Colors.Black)), converter:const StringToSolidColorBrushConverter());

    fontSizeProperty = new FrameworkProperty(
      this,
      "fontSize",
      (value){
        rawElement.style.fontSize = '${value.toString()}px';
      }, converter:const StringToNumericConverter());

    fontFamilyProperty = new FrameworkProperty(
      this,
      "fontFamily",
      (value){
        rawElement.style.fontFamily = value.toString();
      });
  }

  /// Overridden [FrameworkObject] method.
  void createElement()
  {
    //TODO find correct constructor for 'a'.
    rawElement = new Element.tag('a');
  }
}
