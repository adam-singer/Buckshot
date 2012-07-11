// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class PolyLine extends Shape
{
  
  BuckshotObject makeMe() => new PolyLine();
  
  PolyLine(){
    throw const NotImplementedException();
    
    Dom.appendBuckshotClass(rawElement, "polyline");
    _initPolyLineProperties();
  }
  
  void _initPolyLineProperties(){
    
  }
  
  
  String get shapeTag() => 'polyline';
}
