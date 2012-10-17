#library('style_template_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('StyleTemplate', (){
    test('New setter property', (){
      StyleTemplate st = new StyleTemplate();

      Expect.equals(0, st.setters.value.length);

      st.setProperty("background", new SolidColorBrush.fromPredefined(Colors.Red));

      Expect.equals(1, st.setters.value.length);
      Expect.isNotNull(st.getProperty('background'));
    });
    test('Existing setter property', (){
      final st = new StyleTemplate();

      st.setProperty("foo", "bar");
      Expect.equals("bar", st.getProperty('foo'));

      st.setProperty("foo", "apple");
      Expect.equals("apple", st.getProperty('foo'));
    });
    test('Set style to FrameworkElement', (){
      final st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));
      Expect.equals(Colors.Blue.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('Value change binds to property', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));
      Expect.equals(Colors.Blue.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Aqua)));
      Expect.equals(Colors.Aqua.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('null to Element non-null style', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));
      Expect.equals(Colors.Blue.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      int statebagCount = b.stateBag.length;

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
      Expect.equals(statebagCount + 1, b.stateBag.length);
      Expect.isTrue(st.registeredElements.some((e) => e == b));
      Binding bi = b.stateBag['${st.stateBagPrefix}background__'];

      log('$bi');
      b.style.value = null;
      Expect.equals(statebagCount, b.stateBag.length);
      Expect.isFalse(st.registeredElements.some((e) => e == b));
      Expect.isFalse(bi.bindingSet);

      //style is actually reset to a blank style
      Expect.isNotNull(b.style.value);

    });
    test('replace Style', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush.fromPredefined(Colors.Red));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));
      Expect.equals(Colors.Blue.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      int statebagCount = b.stateBag.length;

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
      Expect.equals(statebagCount + 1, b.stateBag.length);
      Expect.isTrue(st.registeredElements.some((e) => e == b));
      Binding bi = b.stateBag['${st.stateBagPrefix}background__'];

      b.style.value = st2;
      Expect.isFalse(st.registeredElements.some((e) => e == b));
      Expect.isTrue(st2.registeredElements.some((e) => e == b));
      Expect.equals(Colors.Green.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
      Expect.isFalse(bi.bindingSet);
    });
    test('.mergeWith no fail on null list', (){
      StyleTemplate st = new StyleTemplate();
      st.mergeWith(null);
    });
    test('.mergeWith no fail if list member null', (){
      StyleTemplate st = new StyleTemplate();
      st.mergeWith([null, null, null]);
    });
    test('.mergeWith same property succeeds', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      b.style.value.mergeWith([st2]);
      Expect.equals(Colors.Green.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('.mergeWith new property succeeds', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("opacity", .5);

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));

      b.style.value = st;
      Expect.isNull(b.opacity.value);

      b.style.value.mergeWith([st2]);
      Expect.equals(.5, b.opacity.value);
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('.mergeWith multiple styles succeeds', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

      StyleTemplate st3 = new StyleTemplate();
      st3.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Yellow)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));

      b.style.value = st;
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());

      //yellow should win
      //st and null should be ignored
      b.style.value.mergeWith([st2, st, null, st3]);
      Expect.equals(Colors.Yellow.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('.mergeWith to new Element style', (){
      StyleTemplate st = new StyleTemplate();
      st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

      StyleTemplate st2 = new StyleTemplate();
      st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

      StyleTemplate st3 = new StyleTemplate();
      st3.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Yellow)));

      var b = new Border();
      b.background.value = new SolidColorBrush(new Color.predefined(Colors.Blue));

      //red should win
      b.style.value.mergeWith([st2, st3, null, st]);
      Expect.equals(Colors.Red.toString(), (b.background.value as SolidColorBrush).color.value.toColorString());
    });
    test('is BuckshotObject', (){
      StyleTemplate st = new StyleTemplate();
      Expect.isTrue(st is BuckshotObject);
    });
  });
}

