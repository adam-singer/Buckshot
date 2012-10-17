#library('template_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

void run(){

  group('Template', (){
    test('event bindings wire up from template', (){
      final vm = new TestViewModel();

      Template
      .deserialize("<button on.click='click_handler' content='click me' />")
      .then(expectAsync1((Button t){
        Expect.isTrue(t is Button, 't is button');

        t.dataContext.value = vm;
        setView(new View.from(t));

        // fire the click event
        t.click.invoke(t, null);

        Expect.equals(42, vm.testProperty.value);
      }));
    });
//    test('registry lookup not found throws', (){
//      String t = "<bar></bar>";
//
//      final test = Template.deserialize(t);
//
//      Expect.throws((){
//        test.then(expectAsync1((tt){
//          print('$tt');
//        }));
//      });
//
//    });

    test('core elements', (){
      String t = '''
          <Stack>
          <Grid></Grid>
          <Border></Border>
          <Button></Button>
          <TextBlock></TextBlock>
          <TextBox></TextBox>
          <Slider></Slider>
          <LayoutCanvas></LayoutCanvas>
          </Stack>
          ''';

      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.isTrue(result is Stack);
        Expect.equals(7, result.children.length);

        Expect.isTrue(result.children[0] is Grid, "Grid");
        Expect.isTrue(result.children[1] is Border, "Border");
        Expect.isTrue(result.children[2] is Button, "Button");
        Expect.isTrue(result.children[3] is TextBlock, "TextBlock");
        Expect.isTrue(result.children[4] is TextBox, "TextBox");
        Expect.isTrue(result.children[5] is Slider, "Slider");
        Expect.isTrue(result.children[6] is LayoutCanvas, "LayoutCanvas");
      }));
    });
    test('simple properties', (){
      String testString = "Hello World";
      String t = '<TextBlock text="$testString"></TextBlock>';
      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(testString, (result as TextBlock).text.value);
      }));
    });
    test('enum properties', (){
      String t = '<Stack orientation="horizontal" valign="center"></Stack>';

      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(Orientation.horizontal, result.orientation.value);
        Expect.equals(VerticalAlignment.center, result.vAlign.value);
      }));
    });
    test('attached properties', (){
      String t = '''
          <Stack Grid.column="3"
          Grid.ROW="4"
          LayoutCanvas.Top="5"
          LayoutCanvas.left="6"
          Grid.columnSpaN="7"
          Grid.rowSpan="8">
          </Stack>
          ''';

      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(3, Grid.getColumn(result));
        Expect.equals(4, Grid.getRow(result));
        Expect.equals(5, LayoutCanvas.getTop(result));
        Expect.equals(6, LayoutCanvas.getLeft(result));
        Expect.equals(7, Grid.getColumnSpan(result));
        Expect.equals(8, Grid.getRowSpan(result));
      }));
    });
//    test('child element of non-container throws', (){
//      String t = "<Slider><TextBlock></TextBlock></Slider>";
//
//      Expect.throws(
//          () {
//            Template.deserialize(t)
//            .then(expectAsync1((result){
//              Expect.isNull(result);
//            }));
//          },
//          (err) => (err is PresentationProviderException)
//      );
//    });
//    test('invalid property node throws', (){
//      String t = "<Slider><fooProperty>bar</fooProperty></Slider>";
//
//      Expect.throws(
//          (){
//            Template.deserialize(t)
//            .then(expectAsync1((result){
//              Expect.isNull(result);
//            }));
//          },
//          (err) => (err is PresentationProviderException)
//      );
//    });
//    test('text in non-container throws', (){
//      String t = "<Slider>hello world</Slider>";
//
//      Expect.throws(
//          ()=> Template.deserialize(t),
//          (err) => (err is PresentationProviderException));
//    });
//    test('text node in list container throws', (){
//      String t = "<Stack>hello world</Stack>";
//
//      Expect.throws(
//          ()=> Template.deserialize(t),
//          (err) => (err is PresentationProviderException));
//    });
    test('simple property node assigns correctly', (){
      String t = "<Stack><width>40</width></Stack>";

      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(40, result.width.value);
      }));
    });
    test('enum property node assigns correctly', (){
      String t = "<Stack><orientation>horizontal</orientation></Stack>";

      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(Orientation.horizontal, (result as Stack).orientation.value);
      }));
    });
    test('attached property node assigns correctly', (){
      final t = "<Stack><grid.column>2</grid.column></Stack>";
      Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(2, Grid.getColumn(result));
      }));
    });
  });
}


class TestViewModel extends ViewModelBase
{
  FrameworkProperty testProperty;

  TestViewModel(){

    if (!reflectionEnabled){
      registerEventHandler('click_handler', click_handler);
    }

    testProperty = new FrameworkProperty(this, 'test');
  }

  void click_handler(sender, args){
    testProperty.value = 42;
  }
}

