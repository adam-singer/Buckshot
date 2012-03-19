class View extends Grid implements IView {
  ViewModel vm;
  
  FrameworkElement get rootVisual() => this;
  
  View(ViewModel this.vm)
  {
    // Build up the UI elements.
    _initUI();
    
  }
  
  void _initUI(){

    //we'll make the visual root container bound to the window's size. stretchy...
    new Binding(LucaSystem.windowWidthProperty, LucaSystem.visualRoot.widthProperty);
    new Binding(LucaSystem.windowHeightProperty, LucaSystem.visualRoot.heightProperty);
    
    //UI for this (Grid)
    LinearGradientBrush lgb = new LinearGradientBrush();
    lgb.direction = LinearGradientDirection.vertical;
    lgb.stops.add(new GradientStop.with(new Color.predefined(Colors.WhiteSmoke)));
    lgb.stops.add(new GradientStop.with(new Color.hex("#AAAAAA")));
    this.background = lgb;
    this.horizontalAlignment = HorizontalAlignment.stretch;
    this.verticalAlignment = VerticalAlignment.stretch;
    this.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
    this.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
    this.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
    
    // this column layout will have the effect of centering the UI horizontally in the browser window
    // there are other ways to do this; this is just one technique
    this.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
    this.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
    this.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
    this.columnDefinitions.add(new ColumnDefinition.with(new GridLength.auto()));
    this.columnDefinitions.add(new ColumnDefinition.with(new GridLength.star(1)));
    
    // Title
    TextBlock title = new TextBlock();
    title.text = "Conway's Game Of Life";
    title.fontSize = 25;
    title.margin = new Thickness(20);
    Grid.setColumnSpan(title, 5);
    title.horizontalAlignment = HorizontalAlignment.center;
    this.children.add(title);
    
    // Game Controls StackPanel
    StackPanel sp = new StackPanel();
    sp.margin = new Thickness.right(10);
    Grid.setRow(sp, 1);
    Grid.setColumn(sp, 1);
    this.children.add(sp);
    
    // Play/Pause Button
    Button btnPlay = new Button();
    btnPlay.content = "Play";
    sp.children.add(btnPlay);
    
    // Reset Button
    Button btnReset = new Button();
    btnReset.content = "Reset";
    sp.children.add(btnReset);
    
//    Button btnStep = new Button();
//    btnStep.content = "Step >>";
//    sp.children.add(btnStep);
    
    TextBlock lblSpeed = new TextBlock();
    lblSpeed.text = "Speed(1-500ms)";
    lblSpeed.margin = new Thickness.top(10);
    sp.children.add(lblSpeed);
    
    Slider slSpeed = new Slider();
    slSpeed.min = 1;
    slSpeed.max = 500;
    slSpeed.value = 1;
    sp.children.add(slSpeed);

    
    // Playfield Border
    Border borderGame = new Border();
    borderGame.borderColor = new SolidColorBrush(new Color.predefined(Colors.Black));
    borderGame.borderThickness = new Thickness(2);
//    borderGame.width = 600;
//    borderGame.height = 600;
    borderGame.horizontalAlignment = HorizontalAlignment.center;
    borderGame.verticalAlignment = VerticalAlignment.center;
    borderGame.background = new SolidColorBrush(new Color.predefined(Colors.Gray));
    Grid.setRow(borderGame, 1);
    Grid.setColumn(borderGame, 2);
    this.children.add(borderGame);
    
    // Statistics Border Container
    Border borderStats = new Border();
    borderStats.width = 150;
    borderStats.height = 100;
    borderStats.padding = new Thickness(5);
    borderStats.borderThickness = new Thickness(1);
    borderStats.margin = new Thickness.specified(0,0,0,10);
    borderStats.borderColor = new SolidColorBrush(new Color.predefined(Colors.Black));
    borderStats.background = new SolidColorBrush(new Color.predefined(Colors.WhiteSmoke));
    Grid.setRow(borderStats, 1);
    Grid.setColumn(borderStats, 3);
    this.children.add(borderStats);
    
    // Grid For Stats
    Grid statsGrid = new Grid();
    statsGrid.horizontalAlignment = HorizontalAlignment.stretch;
    statsGrid.verticalAlignment = VerticalAlignment.stretch;
    statsGrid.columnDefinitions.add(new ColumnDefinition.with(new GridLength.pixel(100)));
    statsGrid.columnDefinitions.add(new ColumnDefinition.with(new GridLength.pixel(50)));
    statsGrid.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
    statsGrid.rowDefinitions.add(new RowDefinition.with(new GridLength.auto()));
    statsGrid.rowDefinitions.add(new RowDefinition.with(new GridLength.star(1)));
    borderStats.content = statsGrid;
    
    StackPanel spLabels = new StackPanel();
    Grid.setRow(spLabels, 1);
    statsGrid.children.add(spLabels);
    
    StackPanel spValues = new StackPanel();
    Grid.setRow(spValues, 1);
    Grid.setColumn(spValues, 1);
    statsGrid.children.add(spValues);
    
    TextBlock lblTitle = new TextBlock();
    lblTitle.text = "Statistics";
    lblTitle.fontSize = 14;
    Grid.setColumnSpan(lblTitle, 2);
    lblTitle.horizontalAlignment = HorizontalAlignment.center;
    statsGrid.children.add(lblTitle);
    
    TextBlock lblGeneration = new TextBlock();
    lblGeneration.text = "Generation";
    lblGeneration.fontSize = 10;
    spLabels.children.add(lblGeneration);
    
    TextBlock lblHighestPop = new TextBlock();
    lblHighestPop.text = "Highest Population";
    lblHighestPop.fontSize = 10;
    spLabels.children.add(lblHighestPop);
    
    TextBlock lblGenerationValue = new TextBlock();
    lblGenerationValue.text = "0";
    lblGenerationValue.fontSize = 10;
    spValues.children.add(lblGenerationValue);
    
    TextBlock lblHighestPopValue = new TextBlock();
    lblHighestPopValue.text = "0";
    lblHighestPopValue.fontSize = 10;
    spValues.children.add(lblHighestPopValue);
    
    
    //events
    btnReset.click + (_, __) => vm.reset();
    btnPlay.click + (_, __) => vm.togglePlayState();
    
    //view model bindings
    new Binding(vm.playButtonTextProperty, btnPlay.contentProperty);
    new Binding(vm.playfieldBorderColorProperty, borderGame.borderColorProperty);
    new Binding(vm.contentAreaProperty, borderGame.contentProperty);
    new Binding(vm.highestPopulationProperty, lblHighestPopValue.textProperty);
    new Binding(vm.generationCountProperty, lblGenerationValue.textProperty);
    
    //notice this binding goes the other way...
    new Binding(slSpeed.valueProperty, vm.speedProperty);
    
  }
}
