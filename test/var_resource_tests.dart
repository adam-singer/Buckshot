#library('resources_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');
#import('package:dart_utils/shared.dart');

run(){
  group('Resources', (){
    test('String values work', (){
      
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
        final result = FrameworkResource.retrieveResource("contenttest");
        
        Expect.isTrue(result is TextBlock);      
      }));
    });
  });
}

