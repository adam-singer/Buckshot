
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

  void attachedPropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><grid.column>2</grid.column></StackPanel>";

    var result = Template.deserialize(t);
    Expect.equals(2, Grid.getColumn(result));
  }

  void enumPropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><orientation>horizontal</orientation></StackPanel>";

    var result = Template.deserialize(t);
    Expect.equals(Orientation.horizontal, result.dynamic.orientation);
  }


  void simplePropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><width>40</width></StackPanel>";

    var result = Template.deserialize(t);
    Expect.equals(40, result.width);
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
    ()=> Template.deserialize(t),
    (err) => (err is FrameworkPropertyResolutionException));
  }

  void childElementOfNonContainerThrows(){
    String t = "<Slider><TextBlock></TextBlock></Slider>";

    Expect.throws(
    ()=> Template.deserialize(t),
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

    var result = Template.deserialize(t);
    Expect.isTrue(result is StackPanel);
    Expect.equals(7, result.dynamic.children.length);

    Expect.isTrue(result.dynamic.children[0] is Grid, "Grid");
    Expect.isTrue(result.dynamic.children[1] is Border, "Border");
    Expect.isTrue(result.dynamic.children[2] is Button, "Button");
    Expect.isTrue(result.dynamic.children[3] is TextBlock, "TextBlock");
    Expect.isTrue(result.dynamic.children[4] is TextBox, "TextBox");
    Expect.isTrue(result.dynamic.children[5] is Slider, "Slider");
    Expect.isTrue(result.dynamic.children[6] is LayoutCanvas, "LayoutCanvas");
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

    var result = Template.deserialize(t);

    Expect.equals(3, Grid.getColumn(result));
    Expect.equals(4, Grid.getRow(result));
    Expect.equals(5, LayoutCanvas.getTop(result));
    Expect.equals(6, LayoutCanvas.getLeft(result));
    Expect.equals(7, Grid.getColumnSpan(result));
    Expect.equals(8, Grid.getRowSpan(result));
  }

  void enumProperties(){
    String t = '<StackPanel orientation="horizontal" valign="center"></StackPanel>';
    var result = Template.deserialize(t);

    Expect.equals(Orientation.horizontal, result.dynamic.orientation);
    Expect.equals(VerticalAlignment.center, result.vAlign);
  }

  void simpleProperties(){
    String testString = "Hello World";
    String t = '<TextBlock text="$testString"></TextBlock>';
    var result = Template.deserialize(t);

    Expect.equals(testString, result.dynamic.text);
  }

  void registryLookupNotFoundThrows(){
    String t = "<foo></foo>";


    Expect.throws(
    ()=> Template.deserialize(t),
    (err)=> (err is PresentationProviderException)
    );
  }
}
