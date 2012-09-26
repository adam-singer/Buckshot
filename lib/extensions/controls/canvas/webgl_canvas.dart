// Copyright (c) 2012, Don Olmstead

#library('webglcanvas.canvas.controls.buckshot');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:DartNet-Event-Model/events.dart');
#import('package:dart_utils/web.dart');

#source('canvas_base.dart');

/**
 * A 3D canvas to draw to.
 */
class WebGLCanvas extends CanvasBase
{
  WebGLRenderingContext _context;

  WebGLCanvas(){
    Browser.appendClass(rawElement, 'webglcanvas');
  }

  WebGLRenderingContext get context {
    if (_context == null) {
      CanvasElement canvas = rawElement as CanvasElement;

      _context = canvas.getContext('experimental-webgl');
    }

    return _context;
  }

  WebGLCanvas.register() : super.register();
  makeMe() => new WebGLCanvas();
}
