class MainUIView implements IView
{
  FrameworkElement _rootElement;
  
  MainUIView(){
      _rootElement = _generateUI();
    
  }
  
  FrameworkElement get rootVisual() => _rootElement;
  
  Border _generateUI(){
    Border rootBorder = new Border();
    rootBorder.margin = new Thickness(10);
    //rootBorder.background = new SolidColorBrush(new Color(Colors.WhiteSmoke));
    rootBorder.borderThickness = new Thickness(5);
    rootBorder.borderColor = new SolidColorBrush(new Color.hex("#AAAAAA"));
    rootBorder.padding = new Thickness(10);
    rootBorder.cornerRadius = 7;
    
    LinearGradientBrush lgb = new LinearGradientBrush();
    
    lgb.direction = LinearGradientDirection.vertical;
    lgb.stops.add(new GradientStop.with(new Color.hex("#ccccff")));
    lgb.stops.add(new GradientStop.with(new Color.hex("#000077")));
    
    rootBorder.background = lgb;
    
    new Binding(buckshot.windowWidthProperty, rootBorder.widthProperty);
    new Binding(buckshot.windowHeightProperty, rootBorder.heightProperty);
    
    Grid g = new Grid();
    //g.background = new SolidColorBrush(new Color(Colors.Yellow));
    //g.height = 300;
    //g.width = 1000;
    g.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
    g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
    g.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
    new Binding(rootBorder.actualWidthProperty, g.widthProperty);
    new Binding(rootBorder.actualHeightProperty, g.heightProperty);
    
    Border contentBorder = new Border();
    Grid.setColumn(contentBorder, 1);
    contentBorder.margin = new Thickness(10);
    contentBorder.horizontalAlignment = HorizontalAlignment.stretch;
    contentBorder.verticalAlignment = VerticalAlignment.stretch;
    contentBorder.background = new SolidColorBrush(new Color.predefined(Colors.Beige));
    g.children.add(contentBorder);
    
    StackPanel sp = new StackPanel();
    TextBlock tb = new TextBlock();
    tb.text = "Select From the List Below";
    sp.children.add(tb);
    
    g.children.add(sp);
   // print ("contentBorder: ${contentBorder.width}, ${contentBorder.height}");
    
    rootBorder.content = g;
    
    return rootBorder;
  }
}
