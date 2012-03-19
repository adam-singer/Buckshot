//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* Describes the thickness of a frame around a rectangle. */
class Thickness{
  final int left, top, right, bottom;
  
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

