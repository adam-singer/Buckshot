library string_to_grid_length_converter_tests_buckshot;

import 'dart:html';
import 'package:buckshot/buckshot_browser.dart';
import 'package:unittest/unittest.dart';


run(){
  group('StringToGridLengthConverter', (){
    final c = const StringToGridLengthConverter();
    test('auto', (){
      GridLength l = c.convert("auto");
      Expect.equals(GridUnitType.auto, l.gridUnitType.value);
    });
    test('pixel', (){
      GridLength l = c.convert("45");
      Expect.equals(45, l.length.value);
      Expect.equals(GridUnitType.pixel, l.gridUnitType.value);
    });
    test('star no value', (){
      GridLength l = c.convert("*");
      Expect.equals(1, l.length.value);
      Expect.equals(GridUnitType.star, l.gridUnitType.value);
    });
    test('star with value', (){
      GridLength l = c.convert("*.5");
      Expect.equals(.5, l.length.value);
      Expect.equals(GridUnitType.star, l.gridUnitType.value);

      GridLength l2 = c.convert(".5*");
      Expect.equals(.5, l2.length.value);
      Expect.equals(GridUnitType.star, l2.gridUnitType.value);
    });
  });
}
