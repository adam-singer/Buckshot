// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Event arguements for mouseMove events */
class MouseEventArgs extends RoutedEventArgs
{
  /// X coords relative to the source [FrameworkElement].
  final num mouseX;
  /// Y coords relative to the source [FrameworkElement].
  final num mouseY;
  /// X coords relative to the browser window.
  final num windowX;
  /// Y coords relative to the browser window.
  final num windowY;

  MouseEventArgs(this.mouseX, this.mouseY, this.windowX, this.windowY);

  String get type() => "MouseEventArgs";

}
