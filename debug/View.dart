/**
* Main View for the demo */
class MainView implements IView {  
  FrameworkElement _rootElement;
  
  MainView(){
   // DEBUG = false;
    //Border g = _generateUI();
    //Grid g = _generateDemoGrid();
    //Border g = _borderTesting();
    //    _generateDemoTextBox(g);
//      _generateDemoGrid(g);
//    _generateDemoRadioButtons(g);
//    _generateDemoCheckBoxes(g);
    
    //_rootElement = g;
  }
 
  FrameworkElement get rootVisual() => _rootElement;
   
  void _generateDemoCheckBoxes(Grid rootGrid){

    
  }
  
  void _generateDemoRadioButtons(Grid rootGrid){
    TextBlock txt = new TextBlock();
    txt.text = "Radio Buttons:";
    txt.verticalAlignment = VerticalAlignment.center;
    Grid.setRow(txt, 2);
    rootGrid.children.add(txt);
        
    StackPanel p = new StackPanel();
    RadioButtonGroup rbg = new RadioButtonGroup();
    
    for (var i = 0; i < 5; ++i){
      StackPanel c = new StackPanel();
      c.orientation = Orientation.horizontal;
  
      RadioButton rb = new RadioButton();
      rb.value = i;
      rb.groupName = "radioSet1";
      rbg.addRadioButton(rb);
      c.children.add(rb);
      if (i == 3) rb.setAsSelected();
      
      TextBlock tb = new TextBlock();
      tb.text = "Radio Button #${i.toString()}";
      tb.margin = new Thickness.specified(0,0,0,10);
      c.children.add(tb);
      p.children.add(c);
    }
    
    rbg.selectionChanged + (_, args){
      print("RadioButton Changed: ${args.selectedRadioButton.groupName}, ${args.selectedRadioButton.value}");
    };
    
    for (var i = 0; i < 5; ++i){
      StackPanel c = new StackPanel();
      c.orientation = Orientation.horizontal;
  
      RadioButton rb = new RadioButton();
      rb.value = i;
      rb.groupName = "radioSet2";
      rb.selectionChanged + radioGroup2Selected;
      c.children.add(rb);
      if (i == 0) rb.setAsSelected();
      
      
      TextBlock tb = new TextBlock();
      tb.text = "Radio Button #${i.toString()}";
      tb.margin = new Thickness.specified(0,0,0,10);
      c.children.add(tb);
      p.children.add(c);
    }
    
    Grid.setColumn(p, 1);
    Grid.setRow(p, 2);
    rootGrid.children.add(p);
    
  }
  
  radioGroup1Selected(RadioButton sender, EventArgs _){
    print("group 1 selection changed: ${sender.groupName}, ${sender.value}");
  }
  
  radioGroup2Selected(RadioButton sender, EventArgs _){
    print("group 2 selection changed: ${sender.groupName}, ${sender.value}");
  }
  
  void _generateDemoTextBox(Grid rootGrid){
    TextBox tb = new TextBox();
    Grid.setColumn(tb, 1);
    rootGrid.children.add(tb);
    
    TextBlock txt = new TextBlock();
    txt.text = "TextBox:";
    txt.verticalAlignment = VerticalAlignment.center;
    rootGrid.children.add(txt);
    
    tb.textChanged + (_, TextChangedEventArgs args){
      txt.text = args.newText;
    };
  }
}
