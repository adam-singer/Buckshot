// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* An element that renders and image from a given [sourceUri] location.
*/
class Image extends FrameworkElement {
  /// Represents the URI location of the image.
  FrameworkProperty sourceUriProperty;
  /// Represents the html alternate text for the image.
  FrameworkProperty altProperty;

  Image(){
    Browser.appendClass(rawElement, "image");
    _initializeImageProperties();
  }
  
  Image.register() : super.register();
  makeMe() => new Image();

  void _initializeImageProperties(){
    sourceUriProperty = new FrameworkProperty(this, "sourceUri", (String value){
      rawElement.attributes["src"] = value.toString();
    });

    altProperty = new FrameworkProperty(this, "alt", (String value){
      rawElement.attributes["alt"] = value.toString();
    }, "undefined");
  }

  /// Gets the [sourceUriProperty] value.
  String get sourceUri => getValue(sourceUriProperty);
  /// Sets the [sourceUriProperty] value.
  set sourceUri(String value) => setValue(sourceUriProperty, value);

  /// Gets the [altProperty] value.
  String get alt => getValue(altProperty);
  /// Sets the [altProperty] value.
  set alt(String value) => setValue(altProperty, value);

  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new ImageElement();
  }
}
