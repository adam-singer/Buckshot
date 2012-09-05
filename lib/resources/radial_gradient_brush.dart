// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.
/**
* Implements a radial gradient [Brush].
*
* ## See Also
* * [LinearGradientBrush]
* * [SolidColorBrush]
*/
class RadialGradientBrush extends Brush {
  /// Represents the [List<GradientStop>] of stops.
  FrameworkProperty stopsProperty;
  /// Represents the [RadialGradientDrawMode] value for the RadialGradientBrush.
  FrameworkProperty drawModeProperty;
  /// Represents the fallback [Color] to use if the browser does not support
  /// gradients.
  FrameworkProperty fallbackColorProperty;

  RadialGradientBrush([RadialGradientDrawMode mode, Color fallback])
  {
    _initRadialGradientProperties();

    if (fallback != null) fallbackColor = fallback;
    if (mode != null) drawMode = mode;
  }
  
  RadialGradientBrush.register() : super.register();
  makeMe() => new RadialGradientBrush();

  /// Sets the [stopsProperty] value.
  set stops(List<GradientStop> value) => setValue(stopsProperty, value);
  /// Gets the [stopsProperty] value.
  List<GradientStop> get stops => getValue(stopsProperty);

  /// Sets the [drawModeProperty] value.
  set drawMode(RadialGradientDrawMode value) => setValue(drawModeProperty, value);
  /// Gets the [drawModeProperty] value.
  RadialGradientDrawMode get drawMode => getValue(drawModeProperty);

  /// Sets the [fallbackColorProperty] value.
  set fallbackColor(Color value) => setValue(fallbackColorProperty, value);
  /// Gets the [fallbackColorProperty] value.
  Color get fallbackColor => getValue(fallbackColorProperty);


  void _initRadialGradientProperties(){
    stopsProperty = new FrameworkProperty(this, "stops",
        defaultValue:new List<GradientStop>());

    drawModeProperty = new FrameworkProperty(this, "drawMode",
        defaultValue:RadialGradientDrawMode.contain,
        converter:const StringToRadialGradientDrawModeConverter());

    fallbackColorProperty = new FrameworkProperty(this, "fallbackColor",
        defaultValue:new Color.predefined(Colors.White));
  }

  /// Overridden [Brush] method.
  void renderBrush(Element element){
    //set the fallback
    element.style.background = fallbackColor.toString();

    final colorString = new StringBuffer();

    //create the string of stop colors
    stops.forEach((GradientStop stop){
      colorString.add(stop.color.toString());

      if (stop.percent != -1)
        colorString.add(" ${stop.percent}%");

      if (stop != stops.last())
        colorString.add(", ");
    });

    //set the background for all browser types
    element.style.background = "-webkit-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "-moz-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "-ms-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "-o-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
  }
}
