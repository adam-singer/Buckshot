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

/// A primitive [Shape] representing rectangle.
class Rectangle extends Shape{
  
  BuckshotObject makeMe() => new Rectangle();
        
  Rectangle(){
    Dom.appendBuckshotClass(_component, "rectangle");
  }
  
  //override shape properties since we are just using a div here instead of SVG element
  _initShapeProperties(){
    
    strokeWidthProperty = new AnimatingFrameworkProperty(this, 'strokeWidth', (value){
      String color = getValue(strokeProperty) != null ? getValue(strokeProperty) : Colors.White.toString();
      
      //TODO support border hatch styles
      
      _component.style.borderTop = 'solid ${value.top}px $color';
      _component.style.borderRight = 'solid ${value.right}px $color';
      _component.style.borderLeft = 'solid ${value.left}px $color';
      _component.style.borderBottom = 'solid ${value.bottom}px $color';
      
    }, 'border-thickness', converter:const StringToNumericConverter());
    
    strokeProperty = new AnimatingFrameworkProperty(this, 'stroke', (value){
      
      shapeElement.style.borderColor = value.color.toString();
      
    }, 'border-color', converter:const StringToSolidColorBrushConverter());
    
    
    fillProperty = new AnimatingFrameworkProperty(this, 'fill', (Brush value){
      
      //TODO Animation hooks won't work because shapeElement is not root
      //need to implement some sort of proxy element solution
      
      value.renderBrush(_component);

    }, 'background', converter:const StringToSolidColorBrushConverter());
    
  }
  
  String get shapeTag() => 'rect';
  
  String get type() => 'Rectangle';
  
  void createElement(){
    _component = Dom.createByTag('div');
  }
}
