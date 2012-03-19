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

class UIBuilder {
  static num i = 0;
  static EventHandlerReference ref;
  
  static Border layout1(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.LightGray));  
    b.cornerRadius = 20;
    b.borderColor = new SolidColorBrush(new Color.hex("#007700"));
    b.borderThickness = new Thickness(5);
    b.width = 300;
    b.height = 300;
    
    var myStackPanel = new StackPanel();
    myStackPanel.horizontalAlignment = HorizontalAlignment.center;
    myStackPanel.verticalAlignment = VerticalAlignment.center;
    //myStackPanel.orientation = Orientation.horizontal;
    
    var myButton = new Button();
    myButton.content = "Click me Button 1";
    
    var myButton2 = new Button();
    myButton2.content = "Click me Button 2";
       
    for(int ii=0; ii<=10; ii++){
      var nb = new TextBlock();
      nb.text = "Luca Text Is really cool. ${ii}";
      nb.fontFamily = "Consolas";
      //nb.margin = new Thickness.Specified(0,0,0,10);
      //nb.visibility = Visibility.collapsed;
      myStackPanel.children.add(nb);
    }
       
    var buttonSP = new StackPanel();
    buttonSP.orientation = Orientation.horizontal;
    buttonSP.children.add(myButton);
    buttonSP.children.add(myButton2);

    myStackPanel.children.add(buttonSP);
   
    b.content = myStackPanel; 
    
    ref = myButton.click + myButtonClickHandler;    

    return b;
  }
  
  static FrameworkElement layout2(){
    //var c = new LucaBorder();
    var c = new LayoutCanvas();
    c.width = 1000;
    c.height = 900;
    c.margin = new Thickness(20);
    c.background = new SolidColorBrush(new Color.predefined(Colors.WhiteSmoke));
    
    var ctb = new TextBlock();
    ctb.text = "Canvased Text Element #1";
    ctb.background = new SolidColorBrush(new Color.predefined(Colors.Yellow));
    LayoutCanvas.setLeft(ctb, 50);
    LayoutCanvas.setTop(ctb, 50);
    c.children.add(ctb);
    
    var ctb2 = new TextBlock();
    ctb2.text = "Canvas Element #2";
    ctb2.background = new SolidColorBrush(new Color.predefined(Colors.Aqua));
    LayoutCanvas.setLeft(ctb2, 65);
    LayoutCanvas.setTop(ctb2, 65);
    c.children.add(ctb2);
    
    ctb.zOrder = 2;
    ctb2.zOrder = 2;
    
    return c;
  }
  
  static void myButtonClickHandler(Dynamic sender, EventArgs e){
    sender.content = "You clicked me ${++i} time${i == 1 ? "" : "s"}.";
    if (i >= 3){
      sender.click - ref;  //unsubscribe the event handler from the event
      sender.content = "No more click events will fire.";
    }
  } 
}
