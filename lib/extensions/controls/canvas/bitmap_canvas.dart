// Copyright (c) 2012, Don Olmstead

#library('webglcanvas.canvas.controls.buckshot');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dart_utils/web.dart');

#source('canvas_base.dart');

/**
 * A 2D Canvas to draw to.
 */
class BitmapCanvas extends CanvasBase
{
  CanvasRenderingContext2D _context;

  BitmapCanvas(){
    Browser.appendClass(rawElement, 'bitmapcanvas');
  }

  CanvasRenderingContext2D get context {
    if (_context == null) {
      CanvasElement canvas = rawElement as CanvasElement;

      _context = canvas.getContext('2d');
    }

    return _context;
  }

  BitmapCanvas.register() : super.register();
  makeMe() => new BitmapCanvas();
}
