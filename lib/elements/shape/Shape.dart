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

/// A base class for primitive shape elements
class Shape extends FrameworkElement
{
  SVGElement shapeElement;
  SVGSVGElement _svgWrapper;
  
  AnimatingFrameworkProperty fillProperty;
  AnimatingFrameworkProperty strokeProperty;
  AnimatingFrameworkProperty strokeWidthProperty;
  
  FrameworkProperty _swProperty;
  FrameworkProperty _shProperty;
  
  Shape(){
    _Dom.appendBuckshotClass(_component, "shape");
    _initShapeProperties();
  }
  
  _initShapeProperties(){
    
    strokeWidthProperty = new AnimatingFrameworkProperty(this, 'strokeWidth', (value){
      shapeElement.style.setProperty('stroke-width', '${value}');
      
    }, 'stroke-width', 0, converter:const StringToNumericConverter());
    
    strokeProperty = new AnimatingFrameworkProperty(this, 'stroke', (value){
      
      shapeElement.style.setProperty('stroke', value.color.toString());
      
    }, 'stroke', converter:const StringToSolidColorBrushConverter());
    
    
    fillProperty = new AnimatingFrameworkProperty(this, 'fill', (Brush value){
      
      //TODO Animation hooks won't work because shapeElement is not root
      //need to implement some sort of proxy element solution
      
      value.renderBrush(shapeElement);

    }, 'fill', converter:const StringToSolidColorBrushConverter());
    
    _swProperty = new FrameworkProperty(this, '_sw', (v){
      if (v is! num) return;
          
      _svgWrapper.attributes['width'] = v;
    });
    
    _shProperty = new FrameworkProperty(this, '_sh', (v){
      if (v is! num) return;
      
      _svgWrapper.attributes['height'] = v;
    });
    
    new Binding(widthProperty, _swProperty);
    new Binding(heightProperty, _shProperty);
  }
  
  Brush get fill() => getValue(fillProperty);
  set fill(Brush v) => setValue(fillProperty, v);
  
  abstract String get shapeTag();
  
  String get type() => 'Shape';
  
  void CreateElement(){
    _component = Dom.createByTag('div');
    
    _svgWrapper = new SVGSVGElement();
    
    shapeElement = new SVGElement.tag(shapeTag);
    _svgWrapper.elements.add(shapeElement);
    _component.elements.add(_svgWrapper); 
  }
}
