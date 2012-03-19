class GridDemoView implements IView
{
  FrameworkElement _rootElement;
  final IMainViewModel _vm;
   
  GridDemoView.with(IMainViewModel this._vm){
    _rootElement = _generateDemoGrid();
  }
  
  FrameworkElement get rootVisual() => _rootElement;
  
  
  
  
  Grid _generateDemoGrid(){
//    TextBlock txt = new TextBlock();
//    txt.text = "Grid:";
//    txt.verticalAlignment = VerticalAlignment.Center;
//    Grid.setRow(txt, 1);
//    rootGrid.children.add(txt);
    
    Grid g = new Grid();
//    g.width = 500;
//    g.height = 500;
//    g.maxWidth = 300;
    g.margin = new Thickness(10);
    new Binding(BuckshotSystem.windowWidthProperty, g.widthProperty);
    new Binding(BuckshotSystem.windowHeightProperty, g.heightProperty);
    //g.background = new SolidColorBrush(new Color(Colors.Orange));
        
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));

    g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
    g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
    g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.pixel(200)));
    g.name = "gridMain";
    
    TextBlock title = new TextBlock();
    title.fontSize = 36;
    title.fontFamily = "Consolas";
    title.margin = new Thickness(5);
    title.horizontalAlignment = HorizontalAlignment.center;
    Grid.setColumnSpan(title, 3);
    
    // Binding to view model property.
    // We can somewhat trust this binding because we are 
    // using the IMainViewModel contract.    
    //
    // However, we don't have to use contracts.  Since Dart is dynamic,
    // we could just refer to the property and assume it's there.
    // Using the loose() constructor, the binding system will quietly 
    // refuse any bindings where either property is null.
    new Binding.loose(_vm.titleProperty, title.textProperty);
    
    g.children.add(title);
    
    for (int r = 1; r < 4; r++){
      for (int c = 0; c < 3; c++){
        Border b = new Border();
        b.borderColor = new SolidColorBrush(new Color.predefined(Colors.Black));
        b.borderThickness = new Thickness(1);
        b.horizontalAlignment = HorizontalAlignment.stretch;
        b.verticalAlignment = VerticalAlignment.stretch;
        b.name = "border${c.toString()}_${(r-1).toString()}";
        //b.background = new SolidColorBrush(new Color(Colors.Yellow));
        //b.height = 25;
        Grid.setColumn(b, c);
        Grid.setRow(b, r);
        g.children.add(b);
        
        TextBlock tb = new TextBlock();
        tb.text = "Grid Cell ($c, ${r - 1})";
        tb.name = "tb${c.toString()}_${(r-1).toString()}";
        //tb.background = new SolidColorBrush(new Color(Colors.White));
        tb.margin = new Thickness(10);
        tb.horizontalAlignment = HorizontalAlignment.center;
        tb.verticalAlignment = VerticalAlignment.center;
        b.content = tb;
      }
    }
    
    g.mouseMove + (_, MouseEventArgs args){
      title.text = "Grid: (${args.mouseX}, ${args.mouseY}), (${args.windowX}, ${args.windowY})";
    };
    
    return g;
    //rootGrid.children.add(g);
  }
}
