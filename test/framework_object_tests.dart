library framework_object_tests_buckshot;

import 'package:buckshot/buckshot_browser.dart';
import 'package:unittest/unittest.dart';

run(){
  group('FrameworkObject', (){
    // Tests that assignment to the name property of a FrameworkObject
    // properly registers it with namedElements
    test('name registration', (){
      var b = new Border();
      b.name.value = "hello";

      Expect.isTrue(namedElements.containsKey("hello"));
    });

  });
}