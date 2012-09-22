#library('border_tests_buckshot');

#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('Border Element', (){
    test('assigning .content to null is handled', (){
      Border b = new Border();
      TextBlock tb = new TextBlock();
      tb.text = "hello";
      
      b.content = tb;
      Expect.equals(tb, b.content, "first assignment of textblock");
      
      b.content = null;
      Expect.isNull(b.content);
      
      b.content = tb;
      Expect.equals(tb, b.content, "second assignment of textblock");
    });
  });
}