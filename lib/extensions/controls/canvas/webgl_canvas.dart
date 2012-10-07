// Copyright (c) 2012, the Buckshot project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache-style license that can be found in the LICENSE file.

#library('webglcanvas.canvas.controls.buckshot');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');
#import('package:buckshot/extensions/controls/canvas/canvas_base.dart');

/**
 * A 3D canvas to draw to.
 */
class WebGLCanvas extends CanvasBase
{
  WebGLRenderingContext _context;

  WebGLCanvas(){
    Browser.appendClass(rawElement, 'webglcanvas');
  }

  WebGLRenderingContext get context => _context;

  WebGLCanvas.register() : super.register();
  makeMe() => new WebGLCanvas();

  void onLoaded() {
    super.onLoaded();

    CanvasElement canvas = rawElement as CanvasElement;

    _context = canvas.getContext('experimental-webgl');
  }

  void onUnloaded() {
    super.onUnloaded();

    _context = null;
  }
}
