class StackPanelDebug implements IView {

  FrameworkElement _rootElement;
  
  StackPanelDebug(){
    _rootElement = _stackPanelTesting();
  }
  
  FrameworkElement get rootVisual() => _rootElement;
  
  FrameworkElement _stackPanelTesting(){
    
    StackPanel sp = new StackPanel();
    sp.background = new SolidColorBrush(new Color.predefined(Colors.Orange));
    sp.orientation = Orientation.vertical;
    
    for (int i = 0; i < 10; i++){
      TextBlock tb = new TextBlock();
      tb.background = new SolidColorBrush(new Color.predefined(Colors.Yellow));
      tb.text = "Hello Moto $i";
      tb.margin = new Thickness(5);
      
      sp.children.add(tb);
    }
    

    return sp;

    
  }
  
}
