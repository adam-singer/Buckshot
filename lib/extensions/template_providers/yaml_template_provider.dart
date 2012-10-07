// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('yaml.templateproviders.buckshotui.org');
#import('dart:json');
#import('package:buckshot/buckshot.dart');
#import('package:xml/xml.dart');
#import('yaml/yaml.dart');

/**
* Provides serialization/deserialization for YAML format templates.
*/
class YAMLTemplateProvider implements IPresentationFormatProvider
{

  XmlElement toXmlTree(String template){
    var yaml = loadYaml(template);

    assert(yaml is List);

    if (yaml.length > 2){
      _err('Expected only 1 or 2 elements in json top level array.');
    }

    if (yaml[0] is! String){
      _err('Expected first element to be a String literal');
    }

    return _nextElement(yaml);
  }

  XmlElement _nextElement(List yaml){
    final e = new XmlElement(yaml[0]);

    if(yaml.length == 1) return e; //no body

    final List body = yaml[1];

    assert(body is List);

    if (body.length > 2){
      _err('Expected between 0 and 2 elements in ${e.name} body.');
    }

    for(final b in body){
      if (b is Map){
        b.forEach((property, value){
          e.attributes[property] = '$value';
        });
      }else if (b is List){
        //iterate
        if (b.length % 2 != 0){
          _err('Expected even number of element/body pairs.');
        }

        for(int i = 0; i < b.length; i+=2){
          e.addChild(_nextElement([b[i], b[i + 1]]));
        }

      }else{
        _err('Type in element body is not recognized.  Should be Map or List.');
      }
    }


    return e;
  }

  /**
  * Takes an object tree starting at [elementRoot] and attempts to
  * convert it to a serialized string
  * in the format of the implementing class. */
  String serialize(FrameworkElement elementRoot){
    throw const NotImplementedException();
  }

  /**
  * Returns true if the given template is detected to be of a compatible format.
  */
  bool isFormat(String template) =>
      !template.startsWith('<') && !template.startsWith('[');

  void _err(String str){
    throw new PresentationProviderException('$str');
  }
}