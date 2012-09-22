#library('string_to_grid_length_converter_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');
#import('package:dart_utils/shared.dart');


run(){
  group('StringToGridLengthConverter', (){
    test('auto', (){
      GridLength l = c.convert("auto");
      Expect.equals(GridUnitType.auto, l.gridUnitType);
    });
    test('pixel', (){
      GridLength l = c.convert("45");
      Expect.equals(45, l.value);
      Expect.equals(GridUnitType.pixel, l.gridUnitType);
    });
    test('star no value', (){
      GridLength l = c.convert("*");
      Expect.equals(1, l.value);
      Expect.equals(GridUnitType.star, l.gridUnitType);
    });
    test('star with value', (){
      GridLength l = c.convert("*.5");
      Expect.equals(.5, l.value);
      Expect.equals(GridUnitType.star, l.gridUnitType);
      
      GridLength l2 = c.convert(".5*");
      Expect.equals(.5, l2.value);
      Expect.equals(GridUnitType.star, l2.gridUnitType);
    });
  });
}
