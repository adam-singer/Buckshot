// Copyright (c) 2012, the Buckshot project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache-style license that can be found in the LICENSE file.

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

  CanvasRenderingContext2D get context => _context;

  BitmapCanvas.register() : super.register();
  makeMe() => new BitmapCanvas();


  void onLoaded() {
    CanvasElement canvas = rawElement as CanvasElement;

    _context = canvas.getContext('2d');
  }

  void onUnloaded() {
    _context = null;
  }
}
