part of core_buckshotui_org;

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
  FrameworkProperty<List<GradientStop>> stops;
  /// Represents the [RadialGradientDrawMode] value for the RadialGradientBrush.
  FrameworkProperty<RadialGradientDrawMode> drawMode;
  /// Represents the fallback [Color] to use if the browser does not support
  /// gradients.
  FrameworkProperty<Color> fallbackColor;

  RadialGradientBrush({RadialGradientDrawMode mode, Color fallback})
  {
    _initRadialGradientProperties();

    if (fallback != null) fallbackColor.value = fallback;
    if (mode != null) drawMode.value = mode;
  }

  RadialGradientBrush.register() : super.register();
  makeMe() => new RadialGradientBrush();

  void _initRadialGradientProperties(){
    stops = new FrameworkProperty(this, "stops",
        defaultValue:new List<GradientStop>());

    drawMode = new FrameworkProperty(this, "drawMode",
        defaultValue:RadialGradientDrawMode.contain,
        converter:const StringToRadialGradientDrawModeConverter());

    fallbackColor = new FrameworkProperty(this, "fallbackColor",
        defaultValue:new Color.predefined(Colors.White));
  }

  /// Overridden [Brush] method.
  void renderBrush(Element element){
    //set the fallback
    element.style.background = fallbackColor.value.toColorString();

    final colorString = new StringBuffer();

    //create the string of stop colors
    stops.value.forEach((GradientStop stop){
      colorString.add(stop.color.value.toColorString());

      if (stop.percent.value != -1) {
        colorString.add(" ${stop.percent.value}%");
      }

      if (stop != stops.value.last()) {
        colorString.add(", ");
      }
    });

    //set the background for all browser types
    element.style.background = "-webkit-radial-gradient(50% 50%, ${drawMode.value}, ${colorString})";
    element.style.background = "-moz-radial-gradient(50% 50%, ${drawMode.value}, ${colorString})";
    element.style.background = "-ms-radial-gradient(50% 50%, ${drawMode.value}, ${colorString})";
    element.style.background = "-o-radial-gradient(50% 50%, ${drawMode.value}, ${colorString})";
    element.style.background = "radial-gradient(50% 50%, ${drawMode.value}, ${colorString})";
  }
}
