
class StyleTemplateTests extends TestGroupBase
{

  registerTests(){

    this.testGroupName = "StyleTemplate Tests";

    testList["New setter property"] = newSetterProperty;
    testList["Existing setter property"] = existingSetterProperty;
    testList["Set style to FrameworkElement"] = applyToElement;
    testList["Value change binds to property"] = valueChangeBindsToProperty;
    testList["null to Element non-null style"] = nullToElementStyleNotNull;
    testList["replaceStyle"] = replaceStyle;
    testList[".mergeWith no fail on null list"] = mergeNoFailNull;
    testList[".mergeWith no fail if list member null"] = mergeNoFailIfListMemberNull;
    testList[".mergeWith same property succeeds"] = mergeSamePropertySucceeds;
    testList[".mergeWith new property succeeds"] = mergeNewPropertySucceeds;
    testList[".mergeWith multiple styles succeeds"] = mergeWithMultiple;
    testList[".mergeWith to new Element style"] = mergeToNewElementStyle;
    testList["is BuckshotObject"] = isBuckshotObject;
  }

  void isBuckshotObject(){
    StyleTemplate st = new StyleTemplate();
    Expect.isTrue(st is BuckshotObject);
  }

  // test whether merging directly to a new element's style succeeds
  // proves that the element style is being properly initialized
  void mergeToNewElementStyle(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    StyleTemplate st2 = new StyleTemplate();
    st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

    StyleTemplate st3 = new StyleTemplate();
    st3.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Yellow)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));

    //red should win
    b.style.mergeWith([st2, st3, null, st]);
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());
  }


  void mergeWithMultiple(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    StyleTemplate st2 = new StyleTemplate();
    st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

    StyleTemplate st3 = new StyleTemplate();
    st3.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Yellow)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));

    b.style = st;
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());

    //yellow should win
    //st and null should be ignored
    b.style.mergeWith([st2, st, null, st3]);
    Expect.equals(Colors.Yellow.toString(), b.background.dynamic.color.toString());
  }

  void mergeNewPropertySucceeds(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    StyleTemplate st2 = new StyleTemplate();
    st2.setProperty("opacity", .5);

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));

    b.style = st;
    Expect.isNull(b.opacity);

    b.style.mergeWith([st2]);
    Expect.equals(.5, b.opacity);
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());
  }

  void mergeSamePropertySucceeds(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    StyleTemplate st2 = new StyleTemplate();
    st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));

    b.style = st;
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());

    b.style.mergeWith([st2]);
    Expect.equals(Colors.Green.toString(), b.background.dynamic.color.toString());
  }

  void mergeNoFailIfListMemberNull(){
    StyleTemplate st = new StyleTemplate();
    st.mergeWith([null, null, null]);
  }

  void mergeNoFailNull(){
    StyleTemplate st = new StyleTemplate();
    st.mergeWith(null);
  }

  void replaceStyle(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    StyleTemplate st2 = new StyleTemplate();
    st2.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Green)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));
    Expect.equals(Colors.Blue.toString(), b.background.dynamic.color.toString());

    int statebagCount = b.stateBag.length;

    b.style = st;
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());
    Expect.equals(statebagCount + 1, b.stateBag.length);
    Expect.isTrue(st.registeredElements.some((e) => e == b));
    Binding bi = b.stateBag['${st.dynamic.stateBagPrefix}background__'];

    b.style = st2;
    Expect.isFalse(st.registeredElements.some((e) => e == b));
    Expect.isTrue(st2.registeredElements.some((e) => e == b));
    Expect.equals(Colors.Green.toString(), b.background.dynamic.color.toString());
    Expect.isFalse(bi.bindingSet);
  }

  void nullToElementStyleNotNull(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));
    Expect.equals(Colors.Blue.toString(), b.background.dynamic.color.toString());

    int statebagCount = b.stateBag.length;

    b.style = st;
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());
    Expect.equals(statebagCount + 1, b.stateBag.length);
    Expect.isTrue(st.registeredElements.some((e) => e == b));
    Binding bi = b.stateBag['${st.dynamic.stateBagPrefix}background__'];

    b.style = null;
    Expect.equals(statebagCount, b.stateBag.length);
    Expect.isFalse(st.registeredElements.some((e) => e == b));
    Expect.isFalse(bi.bindingSet);

    //style is actually reset to a blank style
    Expect.isNotNull(b.style);

  }

  //tests if changes to style setter values are reflected in Elements
  //that the style is assigned to
  void valueChangeBindsToProperty(){
    StyleTemplate st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));
    Expect.equals(Colors.Blue.toString(), b.background.dynamic.color.toString());

    b.style = st;
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());

    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Aqua)));
    Expect.equals(Colors.Aqua.toString(), b.background.dynamic.color.toString());
  }


  void applyToElement(){
    final st = new StyleTemplate();
    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    var b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Blue));
    Expect.equals(Colors.Blue.toString(), b.background.dynamic.color.toString());

    b.style = st;
    Expect.equals(Colors.Red.toString(), b.background.dynamic.color.toString());

  }

  void newSetterProperty(){
    StyleTemplate st = new StyleTemplate();

    Expect.equals(0, st.setters.length);

    st.setProperty("background", new SolidColorBrush(new Color.predefined(Colors.Red)));

    Expect.equals(1, st.setters.length);
    Expect.isNotNull(st.getProperty('background'));
  }

  void existingSetterProperty(){
    final st = new StyleTemplate();

    st.setProperty("foo", "bar");
    Expect.equals("bar", st.getProperty('foo'));

    st.setProperty("foo", "apple");
    Expect.equals("apple", st.getProperty('foo'));
  }
}
