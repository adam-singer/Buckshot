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

class YAMLTemplateProvider extends HashableObject
  implements IPresentationFormatProvider 
{
  //TODO MIME as identifier type instead?
  /**
  * Returns the file extension supported by the implementing class. */
  String get fileExtension() => 'json';
  
  /**
  * Takes a string representation of elements in [template] and 
  * attempts to convert it to an object tree
  * using parsing rules from the implementing class. */
  FrameworkElement deserialize(String template){
    if (!isFormat(template)){
      throw const PresentationProviderException('Template format'
        ' not recognized.');
    }
    
    //convert the yaml into an XmlElement tree and let the 
    //XmlTemplateProvider do the rest...
    
    final p = new XmlTemplateProvider();
    
    return p._getNextElement(_toXmlTree(template));
  }
  
  XmlElement _toXmlTree(String template){
  
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
  
  String get type() => 'JSONTemplateProvider';
}