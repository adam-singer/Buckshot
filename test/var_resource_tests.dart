#library('resources_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

Future run(){
  group('Var Resource', (){
    test('String values work', (){
      var t = '''
          <resourcecollection>
          <var key="test" value="hello world!"></var>
          <var key="colortest" value="#007777"></var>
          <var key="numtest" value="150"></var>
          <var key="urltest" value="http://www.lucastudios.com/img/lucaui_logo_candidate2.png"></var>
          </resourcecollection>
          ''';
      Template.deserialize(t)
      .then(expectAsync1((_){
        Expect.equals("hello world!", getResource("test"));
        Expect.equals("#007777", getResource("colortest"));
        Expect.equals("150", getResource("numtest"));
        Expect.equals("http://www.lucastudios.com/img/lucaui_logo_candidate2.png", getResource("urltest"));
      }));
    });

    test('Object values work', (){
      var t = '''
          <resourcecollection>
          <var key="contenttest">
          <textblock text="hello world!"></textblock>
          </var>
          </resourcecollection>
          ''';

      Template
      .deserialize(t)
      .then(expectAsync1((_){
        final result = getResource("contenttest");

        Expect.isTrue(result is TextBlock);
      }));
    });
  });
}

