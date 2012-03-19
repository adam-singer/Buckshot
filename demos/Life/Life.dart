class Life {
  List<List<int>> matrix;
  List<List<int>> _temporary;
  
  int highestPopulation = 0;
  
  Life(int length) : 
    matrix = new List<List<int>>(length),
    _temporary= new List<List<int>>(length)
  {
    for(var i=0; i < length; ++i) {
      matrix[i] = new List<int>(length);
      _temporary[i] = new List<int>(length);
      for(var j=0; j < length; ++j) {
        _temporary[i][j] = 0;
        matrix[i][j] = 0;
      }
    }
  }
    
  void nextStep() {
    int tempPopulation = 0;
    
    for(var i=0; i<matrix.length; ++i) {
      for(var j=0; j<matrix.length; ++j) {
        if(_neighsAlive(i,j) == 3) {
          _temporary[i][j] = 1;
          tempPopulation++;
        } else if(_neighsAlive(i,j) == 2 && matrix[i][j] == 1) {
          _temporary[i][j] = 1;
          tempPopulation++;
        } else
          _temporary[i][j] = 0;
      }
    }
    
    if (tempPopulation > highestPopulation) highestPopulation = tempPopulation;
    
    for(var i=0; i<matrix.length; ++i) {
      for(var j=0; j<matrix.length; ++j) {
        matrix[i][j] = _temporary[i][j];
      }
    }
  }  
  
  int _neighsAlive(int i, int j) {
    var neighsAlive = 0;
    if(i>0) {
      neighsAlive += matrix[i-1][j];
      if(j>0)
        neighsAlive += matrix[i-1][j-1];
      if(j < matrix.length-1)
        neighsAlive += matrix[i-1][j+1];
    }
    if(j>0) {
      neighsAlive += matrix[i][j-1];
      if(i < matrix.length-1)
        neighsAlive += matrix[i+1][j-1];
      
    }
    if(i < matrix.length-1) {
      neighsAlive += matrix[i+1][j];
      if(j < matrix.length-1)
        neighsAlive += matrix[i+1][j+1];
    }
    if(j < matrix.length-1)
      neighsAlive += matrix[i][j+1];
    return neighsAlive;  
  }
  
  void reset() {
    highestPopulation = 0;
    
    for(var i=0; i < matrix.length; ++i)
      for(var j=0; j < matrix.length; ++j) {
        _temporary[i][j] = 0;
        matrix[i][j] = 0;
        }
  }
}
