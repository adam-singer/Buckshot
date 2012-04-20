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
* Represents an attribute component of an [XmlNode].
*/
class XmlAttribute extends XmlNode
{
  final String name;
  final String value;
  
  XmlAttribute(this.name, this.value)
  :
    super(XmlNodeType.Attribute, const []);
}

/**
* Represents a text node component of an [XmlNode].
*/
class XmlText extends XmlNode
{
  final String text;
    
  XmlText(this.text)
  :
    super(XmlNodeType.Text, const []);
}

/**
* Represents an element of an [XmlNode].
*/
class XmlElement extends XmlNode {
  final String tagName;
  
  XmlElement(this.tagName, [List<XmlNode> elements = const []])
  :
    super(XmlNodeType.Element, new List<XmlNode>())
  {
    addChildren(elements); 
  } 
  
  Collection<XmlAttribute> get attributes() => children.filter((el) => el is XmlAttribute);
  
  Collection<XmlElement> get elements() => children.filter((el) => el is XmlElement || el is XmlText);
    
  String get text() {
    var tNodes = children.filter((el) => el is XmlText);
    if (tNodes.isEmpty()) return '';
    
    var s = new StringBuffer();
    tNodes.forEach((n) => s.add(n.text));
    return s.toString();
  }
  
  void addChild(XmlNode element){
    element.parent = this;
    children.add(element);
  }
  
  void addChildren(List<XmlNode> elements){
    if (!elements.isEmpty()){
      elements.forEach((XmlNode e) => addChild(e));
    }
  }
  
}


class XmlNode {
  final List<XmlNode> children;
  final XmlNodeType type;
  XmlElement parent;
  
  XmlNode(this.type, this.children);
  
  void remove(){
    var i = parent.children.indexOf(this);
    if (i == -1){
      throw const Exception('Element not found.');
    }
    
    parent.children.removeRange(i, 1);
  }
  
  bool hasChildNodes() => !children.isEmpty();
  
  toString() => new XmlStringifier().stringify(this);
}

/**
* Enumerates [XmlNode] types.
*/
class XmlNodeType{
  final String _type;
  
  const XmlNodeType(this._type);
  
  static final Element = const XmlNodeType('Element');
  static final Attribute = const XmlNodeType('Attribute');
  static final Text = const XmlNodeType('Text');
  static final Namespace = const XmlNodeType('Namespace');
  static final Prologue = const XmlNodeType('Prologue');
  static final DocType = const XmlNodeType('DocType');
  
  String toString() => _type;
}

