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
* Implements a Google+ +1 button element.
*
* IMPORTANT!  This element currently does NOT work.  Conflict with Dart javascript code (I think)
* See issue: https://code.google.com/p/dart/issues/detail?id=1042
*
*/
class PlusOne extends FrameworkElement
{
  final String _plusOneJS = 
'''
(function() {
  var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
  po.src = 'https://apis.google.com/js/plusone.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
})();
''';
  
  FrameworkProperty annotationProperty, sizeProperty;
  
  FrameworkObject makeMe() => new PlusOne();
  
  PlusOne(){
    Dom.appendClass(component, "luca_ui_plusone");
    
    _initializePlusOneProperties();
    
    EventHandlerReference ref;

    loaded + (_, __){
      Dom.inject(_plusOneJS);
      loaded - ref;
    };
  }
  
  
  void _initializePlusOneProperties(){
    annotationProperty = new FrameworkProperty(this, "annotation", (PlusOneAnnotationTypes value){
      component.attributes["annotation"] = value.toString();
    }, PlusOneAnnotationTypes.none);
    annotationProperty.stringToValueConverter = const StringToPlusOneAnnotationTypeConverter();
    
    sizeProperty = new FrameworkProperty(this, "size", (PlusOneButtonSizes value){
      component.attributes["size"] = value.toString();
    }, PlusOneButtonSizes.standard);
    sizeProperty.stringToValueConverter = const StringToPlusOneButtonSizeConverter();
  }
  
  PlusOneAnnotationTypes get annotation() => getValue(annotationProperty);
  PlusOneButtonSizes get size() => getValue(sizeProperty);
  
  
  void CreateElement(){
    component = Dom.createByTag("g:plusone");
    component.attributes["annotation"] = "none";
    component.attributes["size"] = "standard";
  }
  
  String get type() => "PlusOne";
}

class PlusOneButtonSizes{
  final String _str;
  const PlusOneButtonSizes(this._str);
  
  static final small = const PlusOneButtonSizes("small");
  static final medium = const PlusOneButtonSizes("medium");
  static final large = const PlusOneButtonSizes("large");
  static final standard = const PlusOneButtonSizes("standard");
  
  String toString() => _str;
}

class PlusOneAnnotationTypes{
  final String _str;
  const PlusOneAnnotationTypes(this._str);
  
  static final inline = const PlusOneAnnotationTypes("inline");
  static final bubble = const PlusOneAnnotationTypes("bubble");
  static final none = const PlusOneAnnotationTypes("none");
  
  String toString() => _str;
}


class StringToPlusOneButtonSizeConverter implements IValueConverter{
  const StringToPlusOneButtonSizeConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
      if (!(value is String)) return value;
      
      switch(value){
        case "small":
          return PlusOneButtonSizes.small;
        case "medium":
          return PlusOneButtonSizes.medium;
        case "large":
          return PlusOneButtonSizes.large;
        case "standard":
          return PlusOneButtonSizes.standard;
        default:
          return PlusOneButtonSizes.standard;
      }
      
  }
}

class StringToPlusOneAnnotationTypeConverter implements IValueConverter{
  const StringToPlusOneAnnotationTypeConverter();
  
  Dynamic convert(Dynamic value, [Dynamic parameter]){
      if (!(value is String)) return value;
      
      switch(value){
        case "inline":
          return PlusOneAnnotationTypes.inline;
        case "bubble":
          return PlusOneAnnotationTypes.bubble;
        case "none":
          return PlusOneAnnotationTypes.none;
        default:
          return PlusOneAnnotationTypes.none;
      }
      
  }
}
