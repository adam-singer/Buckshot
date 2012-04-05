class BorderDemoView implements IView
{
  FrameworkElement _rootElement;
  
  BorderDemoView(){
    _rootElement = _borderTesting();
  }
  
  FrameworkElement get rootVisual() => _rootElement;
  
  Grid grid;
  
  Border _borderTesting(){
    Border rootBorder = new Border();
    rootBorder.name = "rootBorder";
    rootBorder.margin = new Thickness(10);
//    rootBorder.background = new SolidColorBrush(new Color(Colors.WhiteSmoke));
    rootBorder.borderThickness = new Thickness(10);
    rootBorder.borderColor = new SolidColorBrush(new Color.predefined(Colors.Brown));
    
    //RadialGradientBrush lgb = new RadialGradientBrush();
    LinearGradientBrush lgb = new LinearGradientBrush();
    
    //lgb.direction = LinearGradientDirection.topToBottom;
    lgb.stops.add(new GradientStop.with(new Color.predefined(Colors.Orange), 50));
    lgb.stops.add(new GradientStop.with(new Color.predefined(Colors.White)));
    lgb.stops.add(new GradientStop.with(new Color.predefined(Colors.Orange)));
    
    rootBorder.background = lgb;
    
    //rootBorder.padding = new Thickness(10);
//    rootBorder.width = 500;
//    rootBorder.height = 300;
    //rootBorder.cornerRadius = 7;
    
    //bind the window width to the Border's width
    //new Binding(Buckshot.windowWidthProperty, rootBorder.widthProperty);
    //new Binding(Buckshot.windowHeightProperty, rootBorder.heightProperty);
        
    TextBlock tb = new TextBlock();
    tb.margin = new Thickness(10);
    tb.name = "tbHelloWorld";
    tb.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus nunc nunc, lacinia sit amet ultricies non, bibendum quis eros. Integer hendrerit volutpat velit sit amet iaculis. Curabitur eu arcu velit, non blandit nulla. Nullam diam dui, molestie non ultricies a, tristique nec nunc. Nullam hendrerit fringilla nulla non porttitor. Cras orci sapien, porttitor placerat dapibus vitae, pharetra a lectus. Nulla tincidunt lacinia elit ac tempus. Sed sed sem justo, quis facilisis dui. Nullam quis lacus a sapien faucibus mollis. Nam eget dolor turpis.";
    tb.horizontalAlignment = HorizontalAlignment.center;
    tb.verticalAlignment = VerticalAlignment.center;
    tb.width = 500;
    rootBorder.content = tb;
    
//    Grid g = new Grid();
//    grid = g;
//    g.horizontalAlignment = HorizontalAlignment.Stretch;
//    g.verticalAlignment = VerticalAlignment.Stretch;
//    rootBorder.content = g;
    
    return rootBorder;
  }
}
