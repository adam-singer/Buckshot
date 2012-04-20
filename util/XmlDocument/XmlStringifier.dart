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
* Emits a text representation of an [XmlNode] tree.
*/
class XmlStringifier {
  
  /**
  * Returns a text representation of the given [xmlNode] tree.
  */
  String stringify(XmlNode xmlNode){
    StringBuffer s = new StringBuffer();
    _stringifyInternal(s, xmlNode, 0);
    return s.toString();
  }
  
  void _stringifyInternal(StringBuffer b, XmlNode n, int indent){
    switch(n.type){
      case XmlNodeType.Document:
        //TODO support prolog & doctype
        _stringifyInternal(b, n.dynamic.root, 0);
        break;
      case XmlNodeType.Element:
        b.add('\r${_space(indent)}<${n.dynamic.tagName}');
        if (n.hasChildNodes()){
          n.dynamic.attributes.forEach((a) => _stringifyInternal(b, a, indent));
          b.add('>');
          n.dynamic.elements.forEach((e) => _stringifyInternal(b, e, indent + 3));
        }else{
          b.add('>');
        }
        
        if (n.dynamic.elements.length > 0){
          b.add('\r${_space(indent)}</${n.dynamic.tagName}>');
        }else{
          b.add('</${n.dynamic.tagName}>');
        }

        break;
      case XmlNodeType.Attribute:
        b.add(' ${n.dynamic.name}="${n.dynamic.value}"');
        break;
      case XmlNodeType.Text:
        b.add('\r${_space(indent)}${n.dynamic.text}');
        break;
    }
  }
  
  String _space(int amount) {
   StringBuffer s = new StringBuffer();
   for (int i = 0; i < amount; i++){
     s.add(' ');
   }
   return s.toString();
  }
  
}
