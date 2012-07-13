// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

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
    Dom.appendBuckshotClass(rawElement, "shape");
    _initShapeProperties();
  }
  
  _initShapeProperties(){
    
//    strokeWidthProperty = new AnimatingFrameworkProperty(this, 'strokeWidth', (value){
//      shapeElement.style.setProperty('stroke-width', '${value}');
//      
//    }, 'stroke-width', 0, converter:const StringToNumericConverter());
//    
//    strokeProperty = new AnimatingFrameworkProperty(this, 'stroke', (value){
//      
//      shapeElement.style.setProperty('stroke', value.color.toString());
//      
//    }, 'stroke', converter:const StringToSolidColorBrushConverter());
    
    
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
  
  void createElement(){
    rawElement = new DivElement();
//    
//    _svgWrapper = new SVGSVGElement();
//    
//    shapeElement = new SVGElement.tag(shapeTag);
//    _svgWrapper.elements.add(shapeElement);
//    rawElement.elements.add(_svgWrapper); 
  }
}
