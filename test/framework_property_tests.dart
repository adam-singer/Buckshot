#library('framework_properties_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('FrameworkProperty', (){
    test('resolve 1st level property"', (){
      Border b = new Border();
      b.background = new SolidColorBrush(new Color.predefined(Colors.Red));

      b.resolveProperty("background")
      .then(expectAsync1((result){
        Expect.isTrue(result.value is SolidColorBrush);
      }));
    });
    test('resolve nth level property', (){
      final b1 = new Border();
      final b2 = new Border();
      final b3 = new Border();
      final b4 = new Border();
      b1.content = b2;
      b2.content = b3;
      b3.content = b4;

      //set some properties
      b3.width = 45;
      b4.height = 26;

      //get the background from the deepest nested border
      b1.resolveProperty("content.content.content.height")
      .then(expectAsync1((result){
        Expect.equals(26, result.value);
      }));

    //get the width from the 2nd nested border (b3)
    b1.resolveProperty("content.content.width")
      .then(expectAsync1((result){
        Expect.equals(45, result.value);
      }));
    });
    test('resolve returns null on property not found', (){
      Border b = new Border();

      b.resolveProperty("foo")
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
    });
    test('resolve returns null on orphan properties', (){
      Border b = new Border();
      b.background = new SolidColorBrush(new Color.predefined(Colors.Red));

      b.resolveProperty("background.foo")
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
    });
    test('resolve is case in-sensitive', (){
      Border b = new Border();
      b.background = new SolidColorBrush(new Color.predefined(Colors.Red));

      b.resolveProperty("BaCkGrOuNd")
      .then(expectAsync1((result){
        Expect.isTrue(result.value is SolidColorBrush);
      }));
    });
  });
}
