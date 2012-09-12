// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/// A primitive [Shape] representing rectangle.
class Rectangle extends Shape{

  Rectangle(){
    Browser.appendClass(rawElement, "rectangle");
  }
  
  Rectangle.register() : super.register();
  makeMe() => new Rectangle();

  //override shape properties since we are just using a div here instead of SVG element
  _initShapeProperties(){

    strokeWidthProperty = new AnimatingFrameworkProperty(this, 'strokeWidth', 
      'border-thickness', 
      propertyChangedCallback: (value){
        String color = getValue(strokeProperty) != null ? getValue(strokeProperty) : Colors.White.toString();
  
        //TODO support border hatch styles
  
        rawElement.style.borderTop = 'solid ${value.top}px $color';
        rawElement.style.borderRight = 'solid ${value.right}px $color';
        rawElement.style.borderLeft = 'solid ${value.left}px $color';
        rawElement.style.borderBottom = 'solid ${value.bottom}px $color';
  
      }, 
      converter:const StringToNumericConverter());

    strokeProperty = new AnimatingFrameworkProperty(this, 'stroke', 
        'border-color', 
        propertyChangedCallback: (value){
          shapeElement.style.borderColor = value.color.toColorString();
        }, 
        converter:const StringToSolidColorBrushConverter());


    fillProperty = new AnimatingFrameworkProperty(this, 'fill', 
    'background', 
    propertyChangedCallback: (Brush value){
    //TODO Animation hooks won't work because shapeElement is not root
    //need to implement some sort of proxy element solution
      value.renderBrush(rawElement);
    }, 
    converter:const StringToSolidColorBrushConverter());

  }

  String get shapeTag => 'rect';

  void createElement(){
    rawElement = new DivElement();
  }
}
