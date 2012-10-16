#library('binding_testsbuckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');


Future run(){
  group('Bindings', (){
    TestElement e1;
    TestElement e2;

    void resetElements(){
      e1 = new TestElement();
      e2 = new TestElement();
    }

    resetElements();

    test('Test properties are valid', (){
      Expect.isNotNull(e1.a);
      Expect.isNotNull(e1.b);
      Expect.equals(e1.a.value, e1.defaultA);
      Expect.equals(e1.b.value, e1.defaultB);

      Expect.isNotNull(e2.a);
      Expect.isNotNull(e2.b);
      Expect.equals(e2.a.value, e2.defaultA);
      Expect.equals(e2.b.value, e2.defaultB);
    });

    test('Strict binding null pProperties throws', (){
      Expect.throws(
          ()=> bind(e1.a, null, BindingMode.OneWay),
          (err)=> (err is BuckshotException)
      );

      Expect.throws(
          ()=> bind(null, e1.b, BindingMode.OneWay),
          (err)=> (err is BuckshotException)
      );
    });

    test('Binding property to self throws', (){
      Expect.throws(
          ()=> bind(e1.a, e1.a),
          (err)=> (err is BuckshotException)
      );

      Expect.throws(
          ()=> new Binding.loose(e1.a, e1.a),
          (err)=> (err is BuckshotException)
      );
    });

    test('Can bind loosely too null', (){
      Binding b = new Binding.loose(null, e1.b, BindingMode.OneWay);
      Expect.isFalse(b.bindingSet);

      Binding b2 = new Binding.loose(e1.b, null, BindingMode.OneWay);
      Expect.isFalse(b.bindingSet);
    });

    test('One-time binding fires only once', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = bind(e1.a, e2.b, BindingMode.OneTime);

      //should be false because the binding fires and then unregisters
      Expect.isFalse(b.bindingSet);

      Expect.equals(e1.a, e2.b);

      e1.a.value = "one time foo";

      //binding shouldn't fire
      Expect.notEquals("one time foo", e2.b);
      Expect.notEquals(e1.a, e2.b);
    });

    test('One-way binding fires correctly', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = bind(e1.a, e2.b, BindingMode.OneWay);

      Expect.isTrue(b.bindingSet);

      //should now be equal
      Expect.equals(e1.a, e2.b);

      e1.a.value = "binding test";

      //should still be equal
      Expect.equals(e1.a, e2.b);

      //just to be sure...
      Expect.equals("binding test", e2.b);
    });

    test('One-way binding chain succeeds', (){
      resetElements();
      TestElement e3 = new TestElement();
      e3.a.value = "testFoo";

      Expect.notEquals(e1.a, e2.b);
      Expect.notEquals(e2.b, e3.a);

      //setup a binding chain e1.a -> e2.b -> e3.a
      Binding b1 = bind(e1.a, e2.b, BindingMode.OneWay);
      Binding b2 = bind(e2.b, e3.a, BindingMode.OneWay);

      //chain should now be equal
      Expect.equals(e1.a, e2.b);
      Expect.equals(e2.b, e3.a);
      Expect.equals(e1.a, e3.a);

      e1.a.value = "chain test";

      //e3.a should now equal 'chain test';

      Expect.equals("chain test", e3.a.value);
    });

    test('One-way binding unregisters', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = bind(e1.a, e2.b, BindingMode.OneWay);

      Expect.isTrue(b.bindingSet);

      b.unregister();

      Expect.isFalse(b.bindingSet);
    });

    test('Two-way binding unregisters', (){
      resetElements();

      Expect.notEquals(e1.a.value, e2.b.value);

      Binding b = bind(e1.a, e2.b, BindingMode.TwoWay);

      Expect.isTrue(b.bindingSet);

      b.unregister();

      Expect.isFalse(b.bindingSet);
    });

    test('Circular binding doesn\'t overflow', (){
      //not a real easy way to test for overflow
      //just have to try it and see that the unit testing doesn't hang

      resetElements();
      TestElement e3 = new TestElement();
      e3.a.value = "testFoo";

      Expect.notEquals(e1.a, e2.b);
      Expect.notEquals(e2.b, e3.a);

      //setup a binding chain e1.a -> e2.b -> e3.a
      Binding b1 = bind(e1.a, e2.b, BindingMode.OneWay);
      Binding b2 = bind(e2.b, e3.a, BindingMode.OneWay);

      //chain should now be equal
      Expect.equals(e1.a, e2.b);
      Expect.equals(e2.b, e3.a);
      Expect.equals(e1.a, e3.a);

      //now add circular binding...
      Binding b3 = bind(e3.a, e1.a, BindingMode.OneWay);

      //we will never get here if the circular referencing isn't being interrupted

      e1.a.value = "overflow test";

      //again, shouldn't get past here if circular referencing isn't being interrupted

      Expect.equals("overflow test", e1.a);
      Expect.equals("overflow test", e2.b);
      Expect.equals("overflow test", e3.a);
    });

    test('Two-way binding works both ways', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = bind(e1.a, e2.b, BindingMode.TwoWay);

      Expect.isTrue(b.bindingSet);

      //should now be equal
      Expect.equals(e1.a, e2.b);

      e1.a.value = "foo test";

      Expect.equals("foo test", e2.b);

      //now test back...

      e2.b.value = "bar test";

      Expect.equals("bar test", e1.a);
    });

    test('Value converter applies to binding', (){
      resetElements();

      Expect.notEquals(e1.a, e2.b);

      Binding b = bind(e1.a, e2.b, BindingMode.OneWay, new TestValueConverter());

      Expect.isTrue(b.bindingSet);

      Expect.notEquals(e1.a.value, e2.b.value); //e2.b should be upper case

      Expect.equals(e1.a.value.toUpperCase(), e2.b.value);

      e1.a.value = "binding test";

      Expect.equals("binding test", e1.a);
      Expect.equals("BINDING TEST", e2.b);
    });
  });

  return new Future.immediate(true);
}

class TestElement extends FrameworkElement{
  final String defaultA = "property A";
  final String defaultB = "property B";
  FrameworkProperty a, b;

  TestElement(){
    initProperties();
  }

  void initProperties(){
    a = new FrameworkProperty(
      this,
      "a",
      ((String value){

        })
        , defaultA);

    b = new FrameworkProperty(
      this,
      "b",
      ((String value){

      }), defaultB);
  }
}

/**
* A demo value convert which takes any string and converts it to uppercase */
class TestValueConverter implements IValueConverter
{
  Dynamic convert(Dynamic value, [Dynamic parameter]) =>
      (value is String) ? value.toUpperCase() : value;
}
