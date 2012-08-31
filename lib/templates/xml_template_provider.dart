// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Provides serialization/deserialization for XML format templates.
*/
class XmlTemplateProvider implements IPresentationFormatProvider
{
  bool isFormat(String template) => template.startsWith('<');

  String serialize(FrameworkElement elementRoot){
    throw const NotImplementedException();
  }

  XmlElement toXmlTree(String template){
    return XML.parse(template);
  }
}
