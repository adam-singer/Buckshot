// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A button control element.
*/
class Button extends Control implements IFrameworkContainer
{
  Dynamic _content;

  /// Represents the content inside the button.
  FrameworkProperty contentProperty;

  Button()
  {
    Browser.appendClass(rawElement, "button");

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

        //accomodate strings by converting them silently to TextBlock
        if (value is String){
            var tempStr = value;
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

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = contentProperty;
  }

  /// Gets the [contentProperty] value.
  Dynamic get content() => getValue(contentProperty);
  /// Sets the [contentProperty] value.
  set content(Dynamic value) => setValue(contentProperty, value);

  /// Overridden [FrameworkObject] method.
  void createElement()
  {
    rawElement = new ButtonElement();
    rawElement.style.display = 'block';
  }

  String get type() => "Button";

  int _templatePriority() => 20;
}
