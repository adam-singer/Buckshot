part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* An element that renders and image from a given [sourceUri] location.
*/
class Image extends FrameworkElement {
  /// Represents the URI location of the image.
  FrameworkProperty<String> sourceUri;
  /// Represents the html alternate text for the image.
  FrameworkProperty<String> alt;

  Image(){
    Browser.appendClass(rawElement, "image");
    _initializeImageProperties();
  }

  Image.register() : super.register();
  makeMe() => new Image();

  void _initializeImageProperties(){
    sourceUri = new FrameworkProperty(this, "sourceUri",
        propertyChangedCallback: (String value){
      rawElement.attributes["src"] = value.toString();
    });

    alt = new FrameworkProperty(this, "alt",
        propertyChangedCallback: (String value){
      rawElement.attributes["alt"] = value.toString();
    },
    defaultValue: "undefined");
  }

  /// Overridden [FrameworkObject] method.
  void createElement(){
    rawElement = new ImageElement();
  }
}
