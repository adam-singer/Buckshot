#import('ControlGenerator.dart');

String get testTemplate() => 
'''
<stackpanel>
<textbock text='hello world'></textblock>
</stackpanel>
''';

main(){
  generateClassFromXmlTemplate(testTemplate).then((reply){
    print(reply);
  });
}
