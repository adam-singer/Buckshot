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

    view.width = size * length;
    view.height = size * length;
    
    var cells = new List(length * delta);
    
    if (delta < 0){
      // remove uneeded elements from the UI
      for(int i = 0; i < -delta; i++){
        view.children.removeLast();
      }      
    }else{
      // add needed elements to the UI
      print('creating elements');
      for (var i = 0; i < delta * length; i++){                       
          Rectangle b = new Rectangle();
          
//          b.width = size;
//          b.height = size;
//          b.fill = empty;
//          b.click + cellClick;
          var row = (i / length).floor();
          var col = i - (row * length);
//          b.tag = [col.toInt(), row.toInt()];
//          LayoutCanvas.setLeft(b, col * size);
//          LayoutCanvas.setTop(b, row * size);
          cells[i] = i;
          print('$i, ${b.hashCode()}');
      }
      print('finished creating elements');
    }
    
    print('adding to collection');
    view.children.addAll(cells);
    print('finished adding to collection');
    
    model = new Life(length);
  }

  var _lastRedraw = 0;
  void _generate(num time){

    doRedraw(){
      model.nextStep();
      
      generationCount = generationCount + 1;
      
      if (model.highestPopulation > highestPopulation) highestPopulation = model.highestPopulation;
      
      SolidColorBrush color;

      for (int r = 0; r < model.matrix.length; r++){
        for (int c = 0; c < model.matrix.length; c++){
         // color = model.matrix[c][r] == 1 ? occupied : empty;

          view.children[(model.matrix.length * r) + c].dynamic.fill = (model.matrix[c][r] == 1) ? occupied : empty;
        }
      }
    }

    if (!isPaused){
      var diff = time - _lastRedraw;
      if (diff >= speed){
        doRedraw();
        _lastRedraw = time;
      }
    
      window.webkitRequestAnimationFrame(_generate, document.body);
    }
  }
  
  void play()
  {
    isPaused = false;
    _generate(new Date.now().milliseconds);
  }
  
  void pause()
  {
    isPaused = true;
  }
  
  void reset(){
    view.children.forEach((var child) => child.fill = empty );
    
    model.reset();
    generationCount = 0;
    highestPopulation = 0;
  }
  
  void cellClick(Dynamic sender, EventArgs _){
    int isSet = sender.fill == empty ? 1 : 0;
    sender.fill = (isSet == 1) ? occupied : empty; 

    model.matrix[sender.tag[0]][sender.tag[1]] = isSet;
  }
  
  set generationCount(int value) => setValue(generationCountProperty, value);
  int get generationCount() => getValue(generationCountProperty);
  
  set highestPopulation(int value) => setValue(highestPopulationProperty, value);
  int get highestPopulation() => getValue(highestPopulationProperty);
  
  void _initProperties(){
    generationCountProperty = new FrameworkProperty(this, "generationCount", (_){}, 0);
    highestPopulationProperty = new FrameworkProperty(this, "highestPopulation", (_){}, 0);
  }

}
