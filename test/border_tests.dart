library border_tests_buckshot;

import 'package:buckshot/buckshot_browser.dart';
import 'package:unittest/unittest.dart';

run(){
  group('Border Element', (){
    test('assigning .content to null is handled', (){
      Border b = new Border();
      TextBlock tb = new TextBlock()
        ..text.value = "hello";

      b.content.value = tb;
      Expect.equals(tb, b.content.value, "first assignment of textblock");

      b.content.value = null;
      Expect.isNull(b.content.value);

      b.content.value = tb;
      Expect.equals(tb, b.content.value, "second assignment of textblock");
    });
  });
}