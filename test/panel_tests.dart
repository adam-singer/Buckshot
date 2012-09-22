#library('panel_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');
#import('package:dart_utils/shared.dart');

run(){
  group('Panel', (){
    test('Throw when child already has parent.', (){
      Panel p1 = new Panel();
      TextBlock tbTest = new TextBlock();
      p1.children.add(tbTest);
      
      Expect.equals(p1.children[0], tbTest);
      
      Panel p2 = new Panel();
      
      Expect.throws(
          ()=> p2.children.add(tbTest),
          (e)=> (e is BuckshotException)
      );
    });
    
    test('Add child', (){
      Panel p1 = new Panel();
      TextBlock tbTest = new TextBlock();
      p1.children.add(tbTest);
      
      Expect.equals(p1.children[0], tbTest);
    });
  });
}