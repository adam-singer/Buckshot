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
* An element that renders and image from a given [sourceUri] location.
*/
class Image extends FrameworkElement {
  /// Represents the URI location of the image.
  FrameworkProperty sourceUriProperty;
  /// Represents the html alternate text for the image.
  FrameworkProperty altProperty;
  
  /// Overridden [LucaObject] method.
  FrameworkObject makeMe() => new Image();
  
  Image(){
    _Dom.appendBuckshotClass(_component, "image");
    _initializeImageProperties();
  }
  
  
  void _initializeImageProperties(){
    sourceUriProperty = new FrameworkProperty(this, "sourceUri", (String value){
      _component.attributes["src"] = value.toString();
    });
    
    altProperty = new FrameworkProperty(this, "alt", (String value){
      _component.attributes["alt"] = value.toString();
    }, "undefined");
  }
  
  /// Gets the [sourceUriProperty] value.
  String get sourceUri() => getValue(sourceUriProperty);
  /// Sets the [sourceUriProperty] value.
  set sourceUri(String value) => setValue(sourceUriProperty, value);
  
  /// Gets the [altProperty] value.
  String get alt() => getValue(altProperty);
  /// Sets the [altProperty] value.
  set alt(String value) => setValue(altProperty, value);
  
  /// Overridden [FrameworkObject] method.
  void CreateElement(){
    _component = _Dom.createByTag("img");
  }
  
  String get type() => "Image";
}
