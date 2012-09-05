// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('plusone.social.controls.buckshotui.org');

#import('dart:html');
#import('../../../../buckshot.dart');
#import('package:dart_utils/shared.dart');
#import('package:dart_utils/web.dart');

/**
* Implements a Google+ +1 button element.
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

  PlusOne(){
    Browser.appendClass(rawElement, "buckshot_plusone");

    _initializePlusOneProperties();

    var ref;

    ref = loaded + (_, __){
      _inject(_plusOneJS);
      loaded - ref;
    };
  }
  
  PlusOne.register() : super.register();
  makeMe() => new PlusOne();


  void _initializePlusOneProperties(){
    annotationProperty = new FrameworkProperty(this, "annotation", (PlusOneAnnotationTypes value){
      rawElement.attributes["annotation"] = value.toString();
    },
    defaultValue:PlusOneAnnotationTypes.none,
    converter:const StringToPlusOneAnnotationTypeConverter());

    sizeProperty = new FrameworkProperty(this, "size",
    (PlusOneButtonSizes value){
      rawElement.attributes["size"] = value.toString();
    },
    defaultValue:PlusOneButtonSizes.standard,
    converter:const StringToPlusOneButtonSizeConverter());
  }

  PlusOneAnnotationTypes get annotation => getValue(annotationProperty);
  PlusOneButtonSizes get size => getValue(sizeProperty);

  /**
  * Injects javascript into the DOM, and optionally removes it after the script has run. */
  static void _inject(String javascript, [bool removeAfter = false]){
    var s = new Element.tag("script");
    s.attributes["type"] = "text/javascript";
    s.text = javascript;

    document.body.nodes.add(s);

    if (removeAfter != null && removeAfter)
      s.remove();
  }


  void createElement(){
    rawElement = new Element.tag("g:plusone");
    rawElement.attributes["annotation"] = "none";
    rawElement.attributes["size"] = "standard";
  }
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
