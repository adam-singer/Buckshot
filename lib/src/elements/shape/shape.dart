// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/// A base class for primitive shape elements
abstract class Shape extends FrameworkElement
{
  SVGElement shapeElement;
  SVGSVGElement _svgWrapper;

  AnimatingFrameworkProperty<Brush> fill;
  AnimatingFrameworkProperty<Color> stroke;
  AnimatingFrameworkProperty<num> strokeWidth;

  FrameworkProperty<num> _swProperty;
  FrameworkProperty<num> _shProperty;

  Shape(){
    Browser.appendClass(rawElement, "shape");
    _initShapeProperties();
  }

  Shape.register() : super.register();
  makeMe() => null;

  _initShapeProperties(){

//    strokeWidthProperty = new AnimatingFrameworkProperty(this, 'strokeWidth', (value){
//      shapeElement.style.setProperty('stroke-width', '${value}');
//
//    }, 'stroke-width', 0, converter:const StringToNumericConverter());
//
//    strokeProperty = new AnimatingFrameworkProperty(this, 'stroke', (value){
//
//      shapeElement.style.setProperty('stroke', value.color.toColorString());
//
//    }, 'stroke', converter:const StringToSolidColorBrushConverter());


    fill = new AnimatingFrameworkProperty(this, 'fill',
        'fill',
        propertyChangedCallback: (Brush value){
          //TODO Animation hooks won't work because shapeElement is not root
          //need to implement some sort of proxy element solution

          value.renderBrush(shapeElement);
        },
        converter:const StringToSolidColorBrushConverter());

    _swProperty = new FrameworkProperty(this, '_sw', (v){
      if (v is! num) return;

      _svgWrapper.attributes['width'] = '$v';
    });

    _shProperty = new FrameworkProperty(this, '_sh', (v){
      if (v is! num) return;

      _svgWrapper.attributes['height'] = '$v';
    });

    bind(width, _swProperty);
    bind(height, _shProperty);
  }

  abstract String get shapeTag;

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
