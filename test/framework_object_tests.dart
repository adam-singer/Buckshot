#library('framework_object_tests_buckshot');

#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('FrameworkObject', (){
    // Tests that assignment to the name property of a FrameworkObject
    // properly registers it with buckshot.namedElements
    test('name registration', (){
      var b = new Border();
      b.name = "hello";
      
      Expect.isTrue(buckshot.namedElements.containsKey("hello"));
    });
    
  });
}