#library('binding_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');
#import('package:dart_utils/shared.dart');


run(){
  group('Bindings', (){
    TestElement e1;
    TestElement e2;
    
    void resetElements(){
      e1 = new TestElement();
      e2 = new TestElement();
    }
    
    resetElements();
    
    test('Test properties are valid', (){
      Expect.isNotNull(e1._aProperty);
      Expect.isNotNull(e1._bProperty);
      Expect.equals(getValue(e1._aProperty), e1.defaultA);
      Expect.equals(getValue(e1._bProperty), e1.defaultB);

      Expect.isNotNull(e2._aProperty);
      Expect.isNotNull(e2._bProperty);
      Expect.equals(getValue(e2._aProperty), e2.defaultA);
      Expect.equals(getValue(e2._bProperty), e2.defaultB);
    });
    
    test('Strict binding null pProperties throws', (){
      Expect.throws(
          ()=> new Binding(e1._aProperty, null, BindingMode.OneWay),
          (err)=> (err is BuckshotException)
      );

      Expect.throws(
          ()=> new Binding(null, e1._bProperty, BindingMode.OneWay),
          (err)=> (err is BuckshotException)
      );
    });

    test('Binding property to self throws', (){
      Expect.throws(
          ()=> new Binding(e1._aProperty, e1._aProperty),
          (err)=> (err is BuckshotException)
      );

      Expect.throws(
          ()=> new Binding.loose(e1._aProperty, e1._aProperty),
          (err)=> (err is BuckshotException)
      );
    });
    
    test('Can bind loosely too null', (){
      Binding b = new Binding.loose(null, e1._bProperty, BindingMode.OneWay);
      Expect.isFalse(b.bindingSet);

      Binding b2 = new Binding.loose(e1._bProperty, null, BindingMode.OneWay);
      Expect.isFalse(b.bindingSet);
    });
    
    test('One-time binding fires only once', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = new Binding(e1._aProperty, e2._bProperty, BindingMode.OneTime);

      //should be false because the binding fires and then unregisters
      Expect.isFalse(b.bindingSet);

      Expect.equals(e1.a, e2.b);

      e1.a = "one time foo";

      //binding shouldn't fire
      Expect.notEquals("one time foo", e2.b);
      Expect.notEquals(e1.a, e2.b);
    });
    
    test('One-way binding fires correctly', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = new Binding(e1._aProperty, e2._bProperty, BindingMode.OneWay);

      Expect.isTrue(b.bindingSet);

      //should now be equal
      Expect.equals(e1.a, e2.b);

      e1.a = "binding test";

      //should still be equal
      Expect.equals(e1.a, e2.b);

      //just to be sure...
      Expect.equals("binding test", e2.b);
    });
    
    test('One-way binding chain succeeds', (){
      resetElements();
      TestElement e3 = new TestElement();
      e3.a = "testFoo";

      Expect.notEquals(e1.a, e2.b);
      Expect.notEquals(e2.b, e3.a);

      //setup a binding chain e1.a -> e2.b -> e3.a
      Binding b1 = new Binding(e1._aProperty, e2._bProperty, BindingMode.OneWay);
      Binding b2 = new Binding(e2._bProperty, e3._aProperty, BindingMode.OneWay);

      //chain should now be equal
      Expect.equals(e1.a, e2.b);
      Expect.equals(e2.b, e3.a);
      Expect.equals(e1.a, e3.a);

      e1.a = "chain test";

      //e3.a should now equal 'chain test';

      Expect.equals("chain test", e3.a);
    });
    
    test('One-way binding unregisters', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = new Binding(e1._aProperty, e2._bProperty, BindingMode.OneWay);

      Expect.isTrue(b.bindingSet);

      b.unregister();

      Expect.isFalse(b.bindingSet);
    });
    
    test('Two-way binding unregisters', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = new Binding(e1._aProperty, e2._bProperty, BindingMode.TwoWay);

      Expect.isTrue(b.bindingSet);

      b.unregister();

      Expect.isFalse(b.bindingSet);
    });

    test('Circular binding doesn\'t overflow', (){
      //not a real easy way to test for overflow
      //just have to try it and see that the unit testing doesn't hang

      resetElements();
      TestElement e3 = new TestElement();
      e3.a = "testFoo";

      Expect.notEquals(e1.a, e2.b);
      Expect.notEquals(e2.b, e3.a);

      //setup a binding chain e1.a -> e2.b -> e3.a
      Binding b1 = new Binding(e1._aProperty, e2._bProperty, BindingMode.OneWay);
      Binding b2 = new Binding(e2._bProperty, e3._aProperty, BindingMode.OneWay);

      //chain should now be equal
      Expect.equals(e1.a, e2.b);
      Expect.equals(e2.b, e3.a);
      Expect.equals(e1.a, e3.a);

      //now add circular binding...
      Binding b3 = new Binding(e3._aProperty, e1._aProperty, BindingMode.OneWay);

      //we will never get here if the circular referencing isn't being interrupted

      e1.a = "overflow test";

      //again, shouldn't get past here if circular referencing isn't being interrupted

      Expect.equals("overflow test", e1.a);
      Expect.equals("overflow test", e2.b);
      Expect.equals("overflow test", e3.a);
    });
    
    test('Two-way binding works both ways', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = new Binding(e1._aProperty, e2._bProperty, BindingMode.TwoWay);

      Expect.isTrue(b.bindingSet);

      //should now be equal
      Expect.equals(e1.a, e2.b);

      e1.a = "foo test";

      Expect.equals("foo test", e2.b);

      //now test back...

      e2.b = "bar test";

      Expect.equals("bar test", e1.a);
    });
    
    test('Value converter applies to binding', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = new Binding(e1._aProperty, e2._bProperty, BindingMode.OneWay, new TestValueConverter());

      Expect.isTrue(b.bindingSet);

      Expect.notEquals(e1.a, e2.b); //e2.b should be upper case

      Expect.equals(e1.a.toUpperCase(), e2.b);

      e1.a = "binding test";

      Expect.equals("binding test", e1.a);
      Expect.equals("BINDING TEST", e2.b);
    });
  });
}

class TestElement extends FrameworkElement{
  final String defaultA = "property A";
  final String defaultB = "property B";
  FrameworkProperty _aProperty, _bProperty;

  TestElement(){
    initProperties();
  }

  void initProperties(){
    _aProperty = new FrameworkProperty(
      this,
      "_a",
      ((String value){

        })
        , defaultA);

    _bProperty = new FrameworkProperty(
      this,
      "_b",
      ((String value){

      }), defaultB);
  }

  set a(String value) => setValue(_aProperty, value);
  String get a => getValue(_aProperty);

  set b(String value) => setValue(_bProperty, value);
  String get b => getValue(_bProperty);
}

/**
* A demo value convert which takes any string and converts it to uppercase */
class TestValueConverter implements IValueConverter
{

  Dynamic convert(Dynamic value, [Dynamic parameter]) => (value is String) ? value.toUpperCase() : value;

}
