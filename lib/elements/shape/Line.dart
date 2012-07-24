// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class Line extends Shape
{

  BuckshotObject makeMe() => new Line();
  
  Line(){
    throw const NotImplementedException();
    
    Browser.appendClass(rawElement, "line");
    _initLineProperties();
  }
  
  void _initLineProperties(){
    
  }
  
  String get shapeTag() => 'line';
}
