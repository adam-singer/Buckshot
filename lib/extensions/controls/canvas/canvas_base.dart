// Copyright (c) 2012, Don Olmstead

class FrameEventArgs extends EventArgs
{
  int currentTime;

  FrameEventArgs(int this.currentTime);
}

class CanvasBase extends FrameworkElement
{
  static int _nextCanvasId = 0;
  /**
   * Identifier for the canvas.
   *
   * Used to identify the [RequestAnimationFrameCallback]
   * within FrameworkAnimation.
   */
  int _canvasId;

  FrameworkProperty surfaceWidthProperty;
  FrameworkProperty surfaceHeightProperty;

  FrameworkEvent<FrameEventArgs> frame;

  CanvasBase() {
    _canvasId = _nextCanvasId++;

    _initCanvasProperties();
    _initCanvasEvents();

    registerEvent('frame', frame);
  }

  void createElement() {
    rawElement = new Element.tag('canvas');
  }

  CanvasBase.register() : super.register();

  void _initCanvasProperties() {
    surfaceWidthProperty = new FrameworkProperty(this, "surfaceWidth", (num v){
      rawElement.attributes["width"] = v.toString();
    }, 640, converter:const StringToNumericConverter());

    surfaceWidthProperty = new FrameworkProperty(this, "surfaceHeight", (num v){
      rawElement.attributes["height"] = v.toString();
    }, 480, converter:const StringToNumericConverter());
  }

  void _initCanvasEvents() {
    frame = new FrameworkEvent<FrameEventArgs>();

    String name = "canvas_{_canvasId}";
    FrameworkAnimation.workers[name] = _frameHandler;
  }

  bool _frameHandler(e) {
    if (!frame.hasHandlers) return;

    frame.invoke(this, new FrameEventArgs(e));
  }
}
