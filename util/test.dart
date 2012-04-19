#import('ControlGenerator.dart');

String get testTemplate() => 
'''
<stackpanel>
  <textblock name='tbTest' text='hello world'></textblock>
  <textblock name='tbNextLine' text='This is opportunity knocking.'></textblock>
</stackpanel>
''';

main(){
  generateClassFromXmlTemplate(testTemplate).then((reply){
    print(reply);
  });
}
