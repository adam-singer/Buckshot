//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


class BuckshotTemplateProviderTests extends TestGroupBase
{
  final IPresentationFormatProvider p;
  
  BuckshotTemplateProviderTests() : p = new BuckshotTemplateProvider() {}
  
  registerTests(){
    this.testGroupName = "LucaxmlPresentationProvider Tests";
    
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
    testList["comments ignored everywhere"] = commentsIgnored;
    //TODO bindings
    //TODO complex properties (collections)
  }
  
  void commentsIgnored(){
    String t =
      '''
      <!--comment before xml-->
      <stackpanel>
        <!--comment in collection context -->
        <textblock text="Before Border TextBlock">
        <!--comment in textblock -->  
        </textblock>
        <border width="300" height="300" background="Green">
          <textblock horizontalalignment="center" text="In-Border TextBlock" foreground="White">
            <!-- properties can be declared inside the element like so... -->
            <verticalAlignment>center</verticalAlignment>
            <!--comment in collection context -->
          </textblock>
        </border>
        <!--comment in collection context -->
        <textblock text="After Border TextBlock"></textblock>
      </stackpanel>
      <!--comment after xml -->
      ''';
    
    var result = p.deserialize(t);
    
    Expect.isTrue(result is StackPanel);
    
    Expect.equals(3, result.children.length);
    
    Expect.isTrue(result.children[0] is TextBlock);
    Expect.isTrue(result.children[1] is Border);
    Expect.isTrue(result.children[2] is TextBlock);
    
    Expect.isTrue(result.children[1].content is TextBlock);
    Expect.equals(VerticalAlignment.center, result.children[1].content.verticalAlignment);
  }
  
  void attachedPropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><grid.column>2</grid.column></StackPanel>";
    
    var result = p.deserialize(t);
    Expect.equals(2, Grid.getColumn(result));
  }
  
  void enumPropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><orientation>horizontal</orientation></StackPanel>";
    
    var result = p.deserialize(t);
    Expect.equals(Orientation.horizontal, result.orientation);
  }
  
  
  void simplePropertyNodeAssignsCorrectly(){
    String t = "<StackPanel><width>40</width></StackPanel>";
    
    var result = p.deserialize(t);
    Expect.equals(40, result.width);
  }
  
  void textNodeInListContainerThrows(){
    String t = "<StackPanel>hello world</StackPanel>";
    
    Expect.throws(
    ()=> p.deserialize(t),
    (err) => (err is PresentationProviderException && err.message.startsWith("Expected container context to be property")));
  }
  
  
  void textInNonContainerThrows(){
    String t = "<Slider>hello world</Slider>";
    
    Expect.throws(
    ()=> p.deserialize(t),
    (err) => (err is PresentationProviderException && err.message.startsWith("Text node found in element")));
  }
    
  void invalidPropertyNodeThrows(){
    String t = "<Slider><fooProperty>bar</fooProperty></Slider>";
    
    Expect.throws(
    ()=> p.deserialize(t),
    (err) => (err is FrameworkPropertyResolutionException));
  }
  
  void childElementOfNonContainerThrows(){
    String t = "<Slider><TextBlock></TextBlock></Slider>";
    
    Expect.throws(
    ()=> p.deserialize(t),
    (err) => (err is PresentationProviderException && err.message.startsWith("Attempted to add element to another"))
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
    
    var result = p.deserialize(t);
    Expect.isTrue(result is StackPanel);
    Expect.equals(7, result.children.length);
    
    Expect.isTrue(result.children[0] is Grid, "Grid");
    Expect.isTrue(result.children[1] is Border, "Border");
    Expect.isTrue(result.children[2] is Button, "Button");
    Expect.isTrue(result.children[3] is TextBlock, "TextBlock");
    Expect.isTrue(result.children[4] is TextBox, "TextBox");
    Expect.isTrue(result.children[5] is Slider, "Slider");
    Expect.isTrue(result.children[6] is LayoutCanvas, "LayoutCanvas");
  }
  
  void attachedProperties(){
    String t = '''
    <StackPanel Grid.column="3" 
                Grid.ROW="4" 
                LayoutCanvas.top="5" 
                LayoutCanvas.Left="6"
                Grid.columnSpaN="7" 
                Grid.rowSpan="8">
    </StackPanel>
    ''';
    
    var result = p.deserialize(t);
    
    Expect.equals(3, Grid.getColumn(result));
    Expect.equals(4, Grid.getRow(result));
    Expect.equals(5, LayoutCanvas.getTop(result));
    Expect.equals(6, LayoutCanvas.getLeft(result));
    Expect.equals(7, Grid.getColumnSpan(result));
    Expect.equals(8, Grid.getRowSpan(result));
  }
  
  void enumProperties(){
    String t = '<StackPanel orientation="horizontal" verticalAlignment="center"></StackPanel>';
    var result = p.deserialize(t);
    
    Expect.equals(Orientation.horizontal, result.orientation);
    Expect.equals(VerticalAlignment.center, result.verticalAlignment);
  }
  
  void simpleProperties(){
    String testString = "Hello World";
    String t = '<TextBlock text="$testString"></TextBlock>';
    var result = p.deserialize(t);
    
    Expect.equals(testString, result.text);
  }
  
  void registryLookupNotFoundThrows(){
    String t = "<foo></foo>";
    
    
    Expect.throws(
    ()=> p.deserialize(t),
    (err)=> (err is PresentationProviderException)
    );
  }
}
