#library('polly_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:xml/xml.dart');
#import('package:dart_utils/web.dart');
#import('package:dart_utils/shared.dart');
#import('package:unittest/unittest.dart');

run(){
  group('Polly', (){
    test('Class attribute appends properly to null', (){
      Element el = new DivElement();

      Expect.isFalse(el.attributes.containsKey("class"));

      Browser.appendClass(el, "foo");

      Expect.equals("foo", el.attributes["class"], 'doesnt equal foo');
    });

    test('Class attribute appends to existing', (){
      Element el = new DivElement();

      Expect.isFalse(el.attributes.containsKey("class"));

      Browser.appendClass(el, "foo");

      Expect.equals("foo", el.attributes["class"], "doesn't equal 'foo'");

      Browser.appendClass(el, "bar");

      Expect.equals("foo bar", el.attributes["class"], 'doesnt equal foo bar');
    });
  });
}