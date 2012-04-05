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

class FrameworkElementTests extends TestGroupBase
{
  void registerTests(){
    this.testGroupName = "FrameworkElement Tests";
    
    testList["FrameworkElement properties get/set"] = frameworkElementProperties;
    testList["minHeight/maxHeight checks"] = minHeightMaxHeightChecks;
    testList["minWidth/maxWidth checks"] = minWidthMaxWidthChecks;
    testList["resolve current dataContext"] = resolveCurrentDataContext;
    testList["null parent returns null dataContext"] = resolveDataContextNullIfParentNull;
    testList["null returns if current dataContext null"] = resolveDataContextNullIfCurrentNull;
    testList["resolve parent dataContext"] = resolveParentDataContext;
  }
  
  
  // tests that current non-null dataContext is returned
  void resolveCurrentDataContext(){
    var b = new Border();
    b.dataContext = "hello world";
    
    var dc = b.resolveDataContext();
    
    Expect.equals(b.dataContextProperty, dc);
  }
  
  
  // tests that current dataContext of null returns null
  void resolveDataContextNullIfCurrentNull(){
    var b = new Border();
    var dc = b.resolveDataContext();
    
    Expect.isNull(dc);
  }
  
  // test that ancestor datacontext of null returns null
  void resolveDataContextNullIfParentNull(){
    var b = new Border();
    var sp = new StackPanel();
    b.content = sp;
        
    var dc = sp.resolveDataContext();
    
    Expect.isNull(dc);
  }
  
  // tests that datacontext object is resolved from remote ancestor
  void resolveParentDataContext(){
    var b1 = new Border();
    var b2 = new Border();
    var b3 = new Border();
    var b4 = new Border();
    var b5 = new Border();
    var sp = new StackPanel();
    b1.content = b2;
    b2.content = b3;
    b3.content = b4;
    b4.content = b5;
    b5.content = sp;
    b1.dataContext = "hello world";
    
    var dc = sp.resolveDataContext();
    
    Expect.equals("hello world", dc.value);
  }
  

  void minWidthMaxWidthChecks(){
    FrameworkElement fp = new FrameworkElement();
    
    fp.minWidth = 10;
    fp.maxWidth = 100;
        
    fp.width = -5;
    Expect.equals(10, fp.width);
    
    fp.width = 105;
    Expect.equals(100, fp.width);
    
    //now go the other way, making sure that width is adjusted if 
    //max/min widths make it invalid
    
    fp.maxWidth = 75;
    Expect.equals(75, fp.width);
    
    fp.width = 15;
    
    fp.minWidth = 25;
    Expect.equals(25, fp.width);
    
    //check min/max overlap
    fp.minWidth = 80;
    Expect.equals(fp.minWidth, 75);
    
    fp.minWidth = 25;
    fp.maxWidth = 10;
    
    Expect.equals(25, fp.maxWidth);
  }
  
  
  void minHeightMaxHeightChecks(){
    FrameworkElement fp = new FrameworkElement();

    Expect.isNotNull(fp);
    
    fp.height = 10;
    fp.width = 10;
    fp.minHeight = 10;
    fp.maxHeight = 100;

    fp.height = -5;
    Expect.equals(fp.minHeight, fp.height);
    
    fp.height = 105;
    Expect.equals(fp.maxHeight, fp.height);
       
    //now go the other way, making sure that height is adjusted if 
    //max/min heights make it invalid
    
    fp.maxHeight = 75;
    Expect.equals(fp.maxHeight, fp.height);
    
    fp.height = 15;
    
    fp.minHeight = 25;
    Expect.equals(fp.minHeight, fp.height);
        
    //check min/max overlap
    fp.minHeight = 80;
    Expect.equals(fp.minHeight, 75);
    
    fp.minHeight = 25;
    fp.maxHeight = 10;
    
    Expect.equals(25, fp.maxHeight);  
  }
  
  void frameworkElementProperties(){
    FrameworkElement fp = new FrameworkElement();
    
    Expect.isNotNull(fp);

    //check that the default component in initialized properly
    Expect.isNotNull(fp.component);
    Expect.equals(fp.component.tagName, "DIV");
    
    //check default values
    //these checks may seem trivial but we are also validating 
    //the underlying dependency property model for these properties
    Expect.equals(fp.width, "auto", 'width default');
    Expect.equals(fp.height, "auto", 'height default');
    Expect.equals(fp.actualWidth, 0, 'actual width default');
    Expect.equals(fp.actualHeight, 0, 'actual height default');
    Expect.isNull(fp.maxWidth, 'maxWidth default');
    Expect.isNull(fp.maxHeight, 'maxHeight default');
    Expect.isNull(fp.minWidth, 'minWidth default');
    Expect.isNull(fp.minHeight, 'minHeight default');
    Expect.equals(fp.opacity, 1.0, 'opacity default');
    Expect.equals(fp.visibility, Visibility.visible, 'visibility default');
    Expect.equals(fp.margin.toString(), new Thickness(0).toString(), 'margin default');
    Expect.isNull(fp.cursor, 'cursor default');
    Expect.isNull(fp.tag, 'tag default');
    Expect.isNull(fp.dataContext, 'dataContext default');
    Expect.equals(fp.name, null, 'name default');
    Expect.equals(fp.horizontalAlignment, HorizontalAlignment.left, 'horizontalAlignment default');
    Expect.equals(fp.verticalAlignment, VerticalAlignment.top, 'verticalAlignment default');
    
    //make sure property get/set is working correctly
    //(the underlying dependency property system actually)
    fp.width = 30;
    Expect.equals(fp.width, 30, 'width assignment');
    
    fp.height = 40;
    Expect.equals(fp.height, 40, 'height assignment');
    
    fp.maxWidth = 100;
    Expect.equals(fp.maxWidth, 100, 'maxWidth assignment');
    
    fp.minWidth = 0;
    Expect.equals(fp.minWidth, 0, 'maxHeight assignment');
    
    fp.maxHeight = 100;
    Expect.equals(fp.maxHeight, 100, 'maxHeight assignment');
    
    fp.minHeight = 0;
    Expect.equals(fp.minHeight, 0, 'maxWidth assignment');
    
    fp.opacity = .5;
    Expect.equals(fp.opacity, .5, 'opacity assignment');
     
    fp.visibility = Visibility.collapsed;
    Expect.equals(fp.visibility, Visibility.collapsed, 'visibility assignment');
    
    fp.margin = new Thickness.specified(1,2,3,4);
    Expect.equals(fp.margin.toString(), new Thickness.specified(1,2,3,4).toString(), 'margin assignment');
    
    fp.cursor = Cursors.Crosshair;
    Expect.equals(fp.cursor, Cursors.Crosshair, 'cursor assignment');
    
    fp.tag = "hello world";
    Expect.equals(fp.tag, "hello world", 'tag assignment');
    
    fp.dataContext = "data context";
    Expect.equals(fp.dataContext, "data context", 'data context assignment');
    
    fp.name = "control name";
    Expect.equals(fp.name, "control name", 'name assignment');
    
    fp.horizontalAlignment = HorizontalAlignment.right;
    Expect.equals(fp.horizontalAlignment, HorizontalAlignment.right, 'horizontalAlignment assignment');
    
    fp.verticalAlignment = VerticalAlignment.bottom;
    Expect.equals(fp.verticalAlignment, VerticalAlignment.bottom, 'verticalAlignment assignment');
  }
}
