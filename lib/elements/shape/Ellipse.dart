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
class Ellipse extends Shape{
  
  BuckshotObject makeMe() => new Ellipse();
      
  FrameworkProperty _cxProperty;
  FrameworkProperty _cyProperty;
  FrameworkProperty _rxProperty;
  FrameworkProperty _ryProperty;
  
  Ellipse(){
    _Dom.appendBuckshotClass(_component, "ellipse");
    _initEllipseProperties();
  }
  
  void _initEllipseProperties(){    
    _cxProperty = new FrameworkProperty(this, '_cx', (v){
      if (v is! num) return;
      
      var result = v / 2;
      shapeElement.attributes['cx'] = result;
      setValue(_rxProperty, '$result');
      
    });
    
    _cyProperty = new FrameworkProperty(this, '_cy', (v){
      if (v is! num) return;
      
      var result = v / 2;
      shapeElement.attributes['cy'] = result;
      setValue(_ryProperty, '$result');

    });
    
    _rxProperty = new FrameworkProperty(this, '_rx', (v){
      shapeElement.attributes['rx'] = v;
    });
    _ryProperty = new FrameworkProperty(this, '_ry', (v){
      shapeElement.attributes['ry'] = v;
    });
    
    new Binding(widthProperty, _cxProperty);
    new Binding(heightProperty, _cyProperty);
  }
  
  String get shapeTag() => 'ellipse';
  
  String get type() => 'Ellipse';
}
