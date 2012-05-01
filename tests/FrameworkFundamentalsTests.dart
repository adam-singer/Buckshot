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

class FrameworkFundamentalsTests extends TestGroupBase
{

  void registerTests(){
    this.testGroupName = "Framework Fundamentals Tests";

    testList["Render LayoutCanvas"] = layoutCanvasRender;
    testList["Render StackPanel"] = stackPanelRender;
    testList["Render Button"] = buttonRender;
    testList["Render Border"] = borderRender;
    testList["Render TextBlock"] = textBlockRender;
    testList["TextBlock.text add/change"] = textBlockContentAddChange;
    testList["Border.content add/remove"] = borderContentAddRemove;
    //testList["Border.content replace"] = borderContentReplace;
  }


  void textBlockContentAddChange(){
    final String testString = "TextBlock content";
    final String testString2 = "another string";

    TextBlock tb = new TextBlock();
    _renderElement(tb);

    Expect.isNull(tb.text);

    tb.text = testString;

    Expect.equals(tb.text, testString);
    Expect.equals(tb.rawElement.text, tb.text);

    tb.text = "";

    Expect.notEquals(tb.text, testString);

    tb.text = testString2;

    Expect.equals(tb.text, testString2);
    Expect.equals(tb.rawElement.text, tb.text);

    _removeElement(tb);
  }

  void borderContentReplace(){
    final String testString = "TextBlock content";

    Border b = new Border();
    _renderElement(b);

    //verify that the content property begins as null
    Expect.isNull(b.content);

    TextBlock tb = new TextBlock();
    tb.text = testString;

    //check if property is set correctly
    Expect.equals(tb.text, testString);

    b.content = tb;

    //content property is set to correct object
    Expect.equals(b.content, tb);

    //check if the correct information is rendered to the DOM
    Expect.equals(b.rawElement.nodes.length, 1);

    Expect.equals(tb.rawElement.nodes.length, 1);

    Expect.equals(tb.rawElement.nodes[0].text, testString);

    //now replace with a button
    var btn = new Button();
    btn.content = "New button";

    b.content = btn;

    //content property is set to correct object
    Expect.equals(b.content, btn);

    //check if the correct information is rendered to the DOM
    Expect.equals(b.rawElement.nodes.length, 1);

    Expect.equals(b.rawElement.nodes[0].toString(), "BUTTON");

    _removeElement(b);

  }

  void borderContentAddRemove(){
    final String testString = "TextBlock content";

    Border b = new Border();
    _renderElement(b);

    //verify that the content property begins as null
    Expect.isNull(b.content);

    TextBlock tb = new TextBlock();
    tb.text = testString;

    b.content = tb;

    //content property is set to correct object
    Expect.equals(tb, b.content);

    //check if the correct information is rendered to the DOM
    Expect.equals(1, b.rawElement.elements.length);

    b.content = null;

    Expect.isNull(b.content);
    Expect.equals(0, b.rawElement.elements.length);

    _removeElement(b);

  }

  void textBlockRender(){
    _renderAndRemove(new TextBlock());
  }

  void buttonRender(){
    _renderAndRemove(new Button());
  }

  void borderRender(){
    _renderAndRemove(new Border());
  }

  void stackPanelRender(){
    _renderAndRemove(new StackPanel());
  }

  void layoutCanvasRender(){
    _renderAndRemove(new LayoutCanvas());
  }

  void _renderElement(FrameworkElement element){
    //Expect.equals(document.body.childElementCount, 0, "visualRoot should only have 0 element at this point.");

    //document.body.appendchild(element._component);

    //Expect.equals(document.body.childElementCount, 2, "(add)visualRoot should only have 1 element at this point.");
  }

  void _removeElement(FrameworkElement element){
    //Expect.equals(document.body.childElementCount, 2, "(remove)visualRoot should only have 1 element at this point.");

    //document.body.removeChild(element._component);

    //Expect.equals(document.body.childElementCount, 0, "visualRoot should only have 0 element at this point.");
  }

  void _renderAndRemove(FrameworkElement element){
    _renderElement(element);
    _removeElement(element);
  }

}
