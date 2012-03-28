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

/// A primitive [Shape] representing an ellipse.
class Rectangle extends Shape{
  
  BuckshotObject makeMe() => new Rectangle();
      
  FrameworkProperty _cwProperty;
  FrameworkProperty _chProperty;
  
  Rectangle(){
    _Dom.appendBuckshotClass(_component, "rectangle");
    _initRectangleProperties();
  }
  
  void _initRectangleProperties(){    
    _cwProperty = new FrameworkProperty(this, '_cw', (v){
      if (v is! num) return;
      shapeElement.attributes['width'] = v;
    });
    
    _chProperty = new FrameworkProperty(this, '_cy', (v){
      if (v is! num) return;
      shapeElement.attributes['height'] = v;
    });
    
    new Binding(widthProperty, _cwProperty);
    new Binding(heightProperty, _chProperty);
  }
  
  String get shapeTag() => 'rect';
  
  String get type() => 'Rectangle';
}
