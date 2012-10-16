// Copyright (c) 2012, the Buckshot project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache-style license that can be found in the LICENSE file.

#library('webglcanvas.canvas.controls.buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');

/**
 * Event for when a frame changes.
 */
class FrameEventArgs extends EventArgs
{
  /// The current time of the frame
  int currentTime;

  FrameEventArgs(int this.currentTime);
}

/**
 * Base class for canvas drawing.
 */
class CanvasBase extends FrameworkElement
{
  /// Next canvas identifier to hand out
  static int _nextCanvasId = 0;
  /**
   * Identifier for the canvas.
   *
   * Used to identify the [RequestAnimationFrameCallback]
   * within FrameworkAnimation.
   */
  int _canvasId;

  /// The width of the canvas surface
  FrameworkProperty<num> surfaceWidth;
  /// The height of the canvas surface
  FrameworkProperty<num> surfaceHeight;

  /// An event triggered on a change of frame
  FrameworkEvent<FrameEventArgs> frame;

  CanvasBase() {
    _canvasId = _nextCanvasId++;

    _initCanvasProperties();
    _initCanvasEvents();

    registerEvent('frame', frame);
  }

  void createElement() {
    rawElement = new CanvasElement();
  }

  CanvasBase.register() : super.register();

  void onLoaded() {
    super.onLoaded();

    FrameworkAnimation.workers[_name] = _frameHandler;
  }

  void onUnloaded() {
    super.onUnloaded();

    FrameworkAnimation.workers.remove(_name);
  }

  String get _name => "canvas_${_canvasId}";

  void _initCanvasProperties() {
    surfaceWidth = new FrameworkProperty(this, "surfaceWidth", (num v){
      rawElement.attributes["width"] = '$v';
    }, 640, converter:const StringToNumericConverter());

    surfaceHeight = new FrameworkProperty(this, "surfaceHeight", (num v){
      rawElement.attributes["height"] = '$v';
    }, 480, converter:const StringToNumericConverter());
  }

  void _initCanvasEvents() {
    frame = new FrameworkEvent<FrameEventArgs>();
  }

  _frameHandler(e) {
    if (!frame.hasHandlers) return;

    frame.invoke(this, new FrameEventArgs(e));
    return;
  }
}
