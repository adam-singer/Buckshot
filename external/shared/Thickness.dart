// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Describes the thickness of a frame around a rectangle. */
class Thickness{
  final num left, top, right, bottom;
  
  Thickness(int uniformThickness) : 
    left = uniformThickness,
    right = uniformThickness,
    top = uniformThickness,
    bottom = uniformThickness
  { }
  
  Thickness.specified(this.top, this.right, this.bottom, this.left){}
  
  Thickness.top(this.top):
  left = 0,
  right = 0,
  bottom = 0
  {}

  Thickness.right(this.right):
  top = 0,
  left = 0,
  bottom = 0
  {}
  
  Thickness.bottom(this.bottom):
  left = 0,
  top = 0,
  right = 0
  {}
  
  Thickness.left(this.left):
  top = 0,
  right = 0,
  bottom = 0
  {}
  
 
  Thickness.widthheight(int width, int height) :
    left = width,
    right = width,
    top = height,
    bottom = height
    { }
  
  String toString() => "$top $right $bottom $left";
}

