/**
* Represents a View Model for the game View. */
interface ViewModel default _ViewModelImplementation{
  // Using an interface is good practice because it provides a contract to the view
  // and provides a cleaner surface area for auto-complete in the IDE
  
  ViewModel();
  
  FrameworkProperty playButtonTextProperty, 
                    playfieldBorderColorProperty, 
                    contentAreaProperty,
                    generationCountProperty, 
                    highestPopulationProperty,
                    speedProperty;
  
  
  void togglePlayState();
  
  void reset();
}

class _ViewModelImplementation extends ViewModelBase implements ViewModel
{
  View view;
  PlayfieldViewModel playfield;
  EventHandlerReference playClick, resetClick;
  GameState gameState;
  final SolidColorBrush borderColorPlaying, borderColorPaused;
  
  FrameworkProperty playButtonTextProperty, 
                    playfieldBorderColorProperty, 
                    contentAreaProperty,
                    generationCountProperty, 
                    highestPopulationProperty,
                    speedProperty;
  
  _ViewModelImplementation()
  : borderColorPlaying = new SolidColorBrush(new Color.predefined(Colors.Black)),
  borderColorPaused = new SolidColorBrush(new Color.predefined(Colors.Red))
  {
    _initProperties();
    
    _initializeGame();
  }
  
  void _initializeGame(){
    gameState = GameState.paused;
    
    playfield = new PlayfieldViewModel();
    
    view = new View(this);
       
    playfield.setLength(200);

    contentArea = playfield.view;
    
    //set the view
    Buckshot.rootView = view;

    //bindings to the playfield view model
    new Binding(playfield.highestPopulationProperty, highestPopulationProperty);
    new Binding(playfield.generationCountProperty, generationCountProperty);
    
  }
  
  void togglePlayState(){
    gameState = (gameState == GameState.paused) ? GameState.playing : GameState.paused;
    
    switch(gameState){
      case GameState.playing:
        playfield.play();
        playfieldBorderColor = borderColorPlaying;
        playButtonText = "Pause";
        break;
      case GameState.paused:
        playfield.pause();
        playfieldBorderColor = borderColorPaused;
        playButtonText = "Play";
        break;
    }
  }
  
  void reset(){
    if (gameState == GameState.playing) togglePlayState(); 
    playfield.reset();
  }
  
  
  set playButtonText(String value) => setValue(playButtonTextProperty, value);
  
  set playfieldBorderColor(SolidColorBrush value) => setValue(playfieldBorderColorProperty, value);
  
  set contentArea(FrameworkElement value) => setValue(contentAreaProperty, value);
  
  void _initProperties(){
    //initialize framework properties
    playButtonTextProperty = new FrameworkProperty(this, "playButtonText", (_){}, "Play");
    playfieldBorderColorProperty = new FrameworkProperty(this, "playfieldBorderColor", (_){}, borderColorPaused);
    contentAreaProperty = new FrameworkProperty(this, "contentArea", (_){});
    generationCountProperty = new FrameworkProperty(this, "generationCount", (_){}, 0);
    highestPopulationProperty = new FrameworkProperty(this, "highestPopulation", (_){}, 0);
    speedProperty = new FrameworkProperty(this, "speed", (int newSpeed){
      playfield.setSpeed(newSpeed);
    });
  }
  
}
