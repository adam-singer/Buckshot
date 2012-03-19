/**
* Represents a view model for the playfield view. */
interface PlayfieldViewModel default _PlayfieldViewModelImplementation 
{
  PlayfieldViewModel();
  
  FrameworkProperty generationCountProperty, highestPopulationProperty;
  
  void setLength(int length);
  
  void setSpeed(int ms);
  
  void play();
  
  void pause();
  
  void reset();
  
  PlayfieldView view;
}

class _PlayfieldViewModelImplementation extends ViewModelBase implements PlayfieldViewModel
{
  PlayfieldView view;
  Life model;
  StyleTemplate cellStyle;
  int length = 0;
  int intervalHandler;
  int speed = 1;
  bool isPaused = true;
  
  final SolidColorBrush empty, occupied;
  
  FrameworkProperty generationCountProperty, highestPopulationProperty;
  
  _PlayfieldViewModelImplementation():
    empty = new SolidColorBrush(new Color.predefined(Colors.White)),
    occupied = new SolidColorBrush(new Color.predefined(Colors.Black))
  {
    view = new PlayfieldView(this);
    
    _initStyles();
    
    _initProperties();
  }
   
  void setSpeed(int ms){
    if (ms < 1) ms = 1;
    if (ms > 500) ms = 500;
    
    speed = ms;
    
    if (isPaused) return;
    
    pause();
    play();
  }
  
  void setLength(int newLength){
    if (length == newLength) return;
               
    int oldLength = length;
    length = newLength;
    
    int delta = length - oldLength;

    int size = (600 / length).toInt();
    int elementSize = size - 1;

    view.width = size * length;
    view.height = size * length;
    
    if (delta < 0){
      // remove uneeded elements from the UI
      for(int i = 0; i < -delta; i++){
        view.columnDefinitions.removeLast();
        view.rowDefinitions.removeLast();
        view.children.removeLast();
      }      
    }else{
      // add needed elements to the UI
      for (int i = 0; i < delta; i++){       
        view.columnDefinitions.add(new ColumnDefinition.with(new GridLength.pixel(size)));
        view.rowDefinitions.add(new RowDefinition.with(new GridLength.pixel(size)));
        
        for (int c = 0; c < length; c++){
          Border b = new Border();
          b.width = elementSize;
          b.height = elementSize;
          b.background = empty;
          b.click + cellClick;
          view.children.add(b);
        }
      }
    }
    //reposition the child locations
    int index = 0;
    for(int r = 0; r < length; r++){
      for (int c = 0; c < length; c++){
        Grid.setRow(view.children[index], r);
        Grid.setColumn(view.children[index], c);
        index++;        
      }
    }
    
    model = new Life(length);
  }
  
  static bool redrawing = false;
  void _generate(){
    if (redrawing) return;
    redrawing = true;
    model.nextStep();
    
    generationCount = generationCount + 1;
    
    if (model.highestPopulation > highestPopulation) highestPopulation = model.highestPopulation;
    
    SolidColorBrush color;

    for (int r = 0; r < model.matrix.length; r++){
      for (int c = 0; c < model.matrix.length; c++){
        color = model.matrix[c][r] == 1 ? occupied : empty;

        view.children[(model.matrix.length * r) + c].dynamic.background = color;
        
//        var result = view
//          .children
//          .filter((child){return Grid.getColumn(child) == c && Grid.getRow(child) == r;});
        
//          .iterator()
//          .next()
//          .background = color;
      }
    }

    redrawing = false;
  }
  
  void play()
  {
    isPaused = false;
    intervalHandler = window.setInterval(_generate, speed);
  }
  
  void pause()
  {
    isPaused = true;
    if (intervalHandler != null)
      window.clearInterval(intervalHandler);
  }
  
  void reset(){
    view.children.forEach((var child) => child.background = empty );
    
    model.reset();
    generationCount = 0;
    highestPopulation = 0;
  }
  
  void cellClick(Dynamic sender, EventArgs _){
    int isSet = sender.background == empty ? 1 : 0;
    sender.background = (isSet == 1) ? occupied : empty; 

    model.matrix[Grid.getColumn(sender)][Grid.getRow(sender)] = isSet;
  }
  
  set generationCount(int value) => setValue(generationCountProperty, value);
  int get generationCount() => getValue(generationCountProperty);
  
  set highestPopulation(int value) => setValue(highestPopulationProperty, value);
  int get highestPopulation() => getValue(highestPopulationProperty);
  
  void _initProperties(){
    generationCountProperty = new FrameworkProperty(this, "generationCount", (_){}, 0);
    highestPopulationProperty = new FrameworkProperty(this, "highestPopulation", (_){}, 0);
  }
  
  void _initStyles(){

  }
}
