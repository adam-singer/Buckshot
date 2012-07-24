// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class Polygon extends Shape
{
  BuckshotObject makeMe() => new Polygon();
  
  Polygon(){
    throw const NotImplementedException();
    
    Browser.appendClass(rawElement, "polygon");
    _initPolygonProperties();
  }
  
  void _initPolygonProperties(){
    
  }
  
  
  String get shapeTag() => 'polygon';
}
