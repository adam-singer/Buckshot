
void templateTests(){

  test('event bindings wire up from template', (){
    final vm = new TestViewModel();

    Template
      .deserialize("<button on.click='click_handler' content='click me' />")
      .then(expectAsync1((t){
        t.dataContext = vm;
        setView(new View.from(t));

        // fire the click event
        (t as Button).click.invoke(t, null);

        Expect.equals(42, getValue(vm.testProperty));
      }));
  });
}

class TemplateTests extends TestGroupBase
{

  //TODO: JSON & YAML template tests

  registerTests(){
    this.testGroupName = "Template Tests";

    testList["registry lookup not found throws"] = registryLookupNotFoundThrows;
    testList["core elements"] = coreElements;
    testList["simple properties"] = simpleProperties;
    testList["enum properties"] = enumProperties;
    testList["attached properties"] = attachedProperties;
    testList["child element of non-container throws"] = childElementOfNonContainerThrows;
    testList["invalid property node throws"] = invalidPropertyNodeThrows;
    testList["text in non-container throws"] = textInNonContainerThrows;
    testList["text node in list container throws"] = textNodeInListContainerThrows;
    testList["simple property node assigns correctly"] = simplePropertyNodeAssignsCorrectly;
    testList["enum property node assigns correctly"] = enumPropertyNodeAssignsCorrectly;
    testList["attached property node assigns correctly"] = attachedPropertyNodeAssignsCorrectly;
    //TODO bindings
    //TODO complex properties (collections)
  }

  //TODO convert to async
  void attachedPropertyNodeAssignsCorrectly(){
    final t = "<StackPanel><grid.column>2</grid.column></StackPanel>";
    Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(2, Grid.getColumn(result));
      }));
  }

  void enumPropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><orientation>horizontal</orientation></StackPanel>";

    Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(Orientation.horizontal, (result as StackPanel).orientation);
      }));
  }


  void simplePropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><width>40</width></StackPanel>";

    Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(40, result.width);
      }));
  }

  void textNodeInListContainerThrows(){
    String t = "<StackPanel>hello world</StackPanel>";

    Expect.throws(
    ()=> Template.deserialize(t),
    (err) => (err is PresentationProviderException));
  }


  void textInNonContainerThrows(){
    String t = "<Slider>hello world</Slider>";

    Expect.throws(
    ()=> Template.deserialize(t),
    (err) => (err is PresentationProviderException));
  }

  void invalidPropertyNodeThrows(){
    String t = "<Slider><fooProperty>bar</fooProperty></Slider>";

    Expect.throws(
    (){
      Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.isNull(result);
      }));
    },
    (err) => (err is PresentationProviderException)
    );


  }

  void childElementOfNonContainerThrows(){
    String t = "<Slider><TextBlock></TextBlock></Slider>";

    Expect.throws(
    () {
      Template.deserialize(t)
        .then(expectAsync1((result){
          Expect.isNull(result);
        }));
    },
    (err) => (err is PresentationProviderException)
    );
  }

  void coreElements(){
    String t = '''
    <StackPanel>
      <Grid></Grid>
      <Border></Border>
      <Button></Button>
      <TextBlock></TextBlock>
      <TextBox></TextBox>
      <Slider></Slider>
      <LayoutCanvas></LayoutCanvas>
    </StackPanel>
    ''';

    Template.deserialize(t)
        .then(expectAsync1((result){
          Expect.isTrue(result is StackPanel);
          Expect.equals(7, result.children.length);

          Expect.isTrue(result.children[0] is Grid, "Grid");
          Expect.isTrue(result.children[1] is Border, "Border");
          Expect.isTrue(result.children[2] is Button, "Button");
          Expect.isTrue(result.children[3] is TextBlock, "TextBlock");
          Expect.isTrue(result.children[4] is TextBox, "TextBox");
          Expect.isTrue(result.children[5] is Slider, "Slider");
          Expect.isTrue(result.children[6] is LayoutCanvas, "LayoutCanvas");
        }));
  }

  void attachedProperties(){
    String t = '''
    <StackPanel Grid.column="3" 
                Grid.ROW="4" 
                LayoutCanvas.Top="5" 
                LayoutCanvas.left="6"
                Grid.columnSpaN="7" 
                Grid.rowSpan="8">
    </StackPanel>
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
  }

  void enumProperties(){
    String t = '<StackPanel orientation="horizontal" valign="center"></StackPanel>';

    Template
      .deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(Orientation.horizontal, result.orientation);
        Expect.equals(VerticalAlignment.center, result.vAlign);
      }));
  }

  void simpleProperties(){
    String testString = "Hello World";
    String t = '<TextBlock text="$testString"></TextBlock>';
    Template.deserialize(t)
      .then(expectAsync1((result){
        Expect.equals(testString, (result as TextBlock).text);
      }));
  }

  void registryLookupNotFoundThrows(){
    String t = "<foo></foo>";

    Expect.throws(
    ()=> Template.deserialize(t),
    (err)=> (err is PresentationProviderException)
    );
  }
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
    setValue(testProperty, 42);
  }
}

