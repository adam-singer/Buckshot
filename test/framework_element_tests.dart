#library('framework_element_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('FrameworkElement', (){
    test('properties get/set', (){
      FrameworkElement fp = new FrameworkElement();

      Expect.isNotNull(fp);

      //check that the default component in initialized properly
      Expect.isNotNull(fp.rawElement);
      Expect.equals(fp.rawElement.tagName, "DIV");

      //check default values
      //these checks may seem trivial but we are also validating
      //the underlying dependency property model for these properties
      Expect.equals('auto', fp.width, 'width default');
      Expect.equals('auto', fp.height, 'height default');
      Expect.isNull(fp.actualWidth, 'actual width default');
      Expect.isNull(fp.actualHeight, 'actual height default');
      Expect.isNull(fp.maxWidth, 'maxWidth default');
      Expect.isNull(fp.maxHeight, 'maxHeight default');
      Expect.isNull(fp.minWidth, 'minWidth default');
      Expect.isNull(fp.minHeight, 'minHeight default');
      Expect.isNull(fp.opacity, 'opacity default');
      Expect.isNull(fp.visibility, 'visibility default');
      Expect.equals(fp.margin.toString(), new Thickness(0).toString(), 'margin default');
      Expect.isNull(fp.cursor, 'cursor default');
      Expect.isNull(fp.tag, 'tag default');
      Expect.isNull(fp.dataContext, 'dataContext default');
      Expect.equals(fp.name, null, 'name default');
      Expect.equals(fp.hAlign, HorizontalAlignment.left, 'horizontalAlignment default');
      Expect.equals(fp.vAlign, VerticalAlignment.top, 'verticalAlignment default');

      //make sure property get/set is working correctly
      //(the underlying dependency property system actually)
      fp.width.value = 30;
      Expect.equals(fp.width.value, 30, 'width assignment');

      fp.height.value = 40;
      Expect.equals(fp.height.value, 40, 'height assignment');

      fp.maxWidth.value = 100;
      Expect.equals(fp.maxWidth.value, 100, 'maxWidth assignment');

      fp.minWidth.value = 0;
      Expect.equals(fp.minWidth.value, 0, 'maxHeight assignment');

      fp.maxHeight.value = 100;
      Expect.equals(fp.maxHeight.value, 100, 'maxHeight assignment');

      fp.minHeight.value = 0;
      Expect.equals(fp.minHeight.value, 0, 'maxWidth assignment');

      fp.opacity.value = .5;
      Expect.equals(fp.opacity.value, .5, 'opacity assignment');

      fp.visibility.value = Visibility.collapsed;
      Expect.equals(fp.visibility.value, Visibility.collapsed, 'visibility assignment');

      fp.margin.value = new Thickness.specified(1,2,3,4);
      Expect.equals(fp.margin.value.toString(), new Thickness.specified(1,2,3,4).toString(), 'margin assignment');

      fp.cursor.value = Cursors.Crosshair;
      Expect.equals(fp.cursor.value, Cursors.Crosshair, 'cursor assignment');

      fp.tag.value = "hello world";
      Expect.equals(fp.tag.value, "hello world", 'tag assignment');

      fp.dataContext.value = "data context";
      Expect.equals(fp.dataContext.value, "data context", 'data context assignment');

      fp.name.value = "control name";
      Expect.equals(fp.name, "control name", 'name assignment');

      fp.hAlign.value = HorizontalAlignment.right;
      Expect.equals(fp.hAlign, HorizontalAlignment.right, 'horizontalAlignment assignment');

      fp.vAlign.value = VerticalAlignment.bottom;
      Expect.equals(fp.vAlign.value, VerticalAlignment.bottom, 'verticalAlignment assignment');
    });
    test('minHeight/maxHeight', (){
      FrameworkElement fp = new FrameworkElement();

      Expect.isNotNull(fp);

      fp.height.value = 10;
      fp.width.value = 10;
      fp.minHeight.value = 10;
      fp.maxHeight.value = 100;

      fp.height.value = -5;
      Expect.equals(fp.minHeight.value, fp.height.value);

      fp.height.value = 105;
      Expect.equals(fp.maxHeight.value, fp.height.value);

      //now go the other way, making sure that height is adjusted if
      //max/min heights make it invalid

      fp.maxHeight.value = 75;
      //Expect.equals(fp.maxHeight, fp.height);

      fp.height.value = 15;

      fp.minHeight.value = 25;
      //Expect.equals(fp.minHeight, fp.height);

      //check min/max overlap
      fp.minHeight.value = 80;
      //Expect.equals(75, fp.minHeight);

      fp.minHeight.value = 25;
      fp.maxHeight.value = 10;

      //Expect.equals(25, fp.maxHeight);
    });
    test('minWidth/maxWidth', (){
      FrameworkElement fp = new FrameworkElement();

      fp.minWidth.value = 10;
      fp.maxWidth.value = 100;

      fp.width.value = -5;
      Expect.equals(10, fp.width);

      fp.width.value = 105;
      Expect.equals(100, fp.width);

      //now go the other way, making sure that width is adjusted if
      //max/min widths make it invalid

      fp.maxWidth.value = 75;
      //Expect.equals(75, fp.width);

      fp.width.value = 15;

      fp.minWidth.value = 25;
      //Expect.equals(25, fp.width);

      //check min/max overlap
      fp.minWidth.value = 80;
      //Expect.equals(75, fp.minWidth);

      fp.minWidth.value = 25;
      fp.maxWidth.value = 10;

      //Expect.equals(25, fp.maxWidth);
    });
    test('resolves to dataContext', (){
      var b = new Border();
      b.dataContext.value = "hello world";

      var dc = b.resolveDataContext();

      Expect.equals(b.dataContext, dc);
    });
    test('null parent returns null dataContext', (){
      var b = new Border();
      var sp = new Stack();
      b.content.value = sp;

      var dc = sp.resolveDataContext();

      Expect.isNull(dc);
    });
    test('null returns on current dataContext null', (){
      var b = new Border();
      var dc = b.resolveDataContext();

      Expect.isNull(dc);
    });
    test('resolve parent dataContext', (){
      var b1 = new Border();
      var b2 = new Border();
      var b3 = new Border();
      var b4 = new Border();
      var b5 = new Border();
      var sp = new Stack();
      b1.content.value = b2;
      b2.content.value = b3;
      b3.content.value = b4;
      b4.content.value = b5;
      b5.content.value = sp;
      b1.dataContext.value = "hello world";

      var dc = sp.resolveDataContext();

      Expect.equals("hello world", dc.value);
    });
  });
}