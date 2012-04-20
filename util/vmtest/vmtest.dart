#import('../XmlDocument/XmlDocument.dart');

void main() {
 
  XmlElement test = new XmlElement('StackPanel',
    [new XmlElement('TextBlock',
       [
        new XmlAttribute('text', 'hello world!'),
        new XmlAttribute('fontSize', '12')
       ]),
     new XmlElement('Border', 
       [
        new XmlElement('Image', 
          [
           new XmlText('Now is the time for all good people to blah blah blah')
          ])
       ])
    ]);
  
  print(test);
}
