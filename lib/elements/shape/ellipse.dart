// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 *  A primitive [Shape] representing an ellipse.
 */
class Ellipse extends Shape{

  FrameworkProperty _cxProperty;
  FrameworkProperty _cyProperty;
  FrameworkProperty _rxProperty;
  FrameworkProperty _ryProperty;

  Ellipse(){
    Browser.appendClass(rawElement, "ellipse");
    _initEllipseProperties();
  }

  void _initEllipseProperties(){
    _cxProperty = new FrameworkProperty(this, '_cx', (v){
      if (v is! num) return;

      var result = v / 2;
      shapeElement.attributes['cx'] = '$result';
      setValue(_rxProperty, result);

    });

    _cyProperty = new FrameworkProperty(this, '_cy', (v){
      if (v is! num) return;

      var result = v / 2;
      shapeElement.attributes['cy'] = '$result';
      setValue(_ryProperty, result);

    });

    _rxProperty = new FrameworkProperty(this, '_rx', (v){
      shapeElement.attributes['rx'] = '${v - getValue(strokeWidthProperty) / 2}';
    });
    _ryProperty = new FrameworkProperty(this, '_ry', (v){
      shapeElement.attributes['ry'] = '${v - getValue(strokeWidthProperty) / 2}';
    });

    new Binding(widthProperty, _cxProperty);
    new Binding(heightProperty, _cyProperty);
  }

  String get shapeTag => 'ellipse';
}
