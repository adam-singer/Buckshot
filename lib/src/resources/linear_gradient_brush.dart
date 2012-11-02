part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a gradient blend between two [Color]s.
*
* ## See Also
* * [RadialGradientBrush]
* * [SolidColorBrush]
*/
class LinearGradientBrush extends Brush
{
  /// Represents the [List<GradientStop>] collection of stops.
  FrameworkProperty<List<GradientStop>> stops;
  /// Represents the [LinearGradientDirection] of the LinearGradientBrush.
  FrameworkProperty<LinearGradientDirection> direction;
  /// Represents the fall back [Color] to use if gradients aren't supported.
  FrameworkProperty<Color> fallbackColor;

  LinearGradientBrush({LinearGradientDirection dir, Color fallback})
  {
    _initLinearGradientBrushProperties();

    if (dir != null) direction.value = dir;//LinearGradientDirection.horizontal;
    if (fallback != null) fallbackColor.value = fallback;// = new Color.predefined(Colors.White);

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = stops;
  }

  LinearGradientBrush.register() : super.register();
  makeMe() => new LinearGradientBrush();

  void _initLinearGradientBrushProperties(){
    stops = new FrameworkProperty(this, "stops",
        defaultValue:new List<GradientStop>());

    direction = new FrameworkProperty(this, "direction",
        defaultValue:LinearGradientDirection.horizontal,
        converter:const StringToLinearGradientDirectionConverter());

    fallbackColor = new FrameworkProperty(this, "fallbackColor",
        defaultValue:new Color.predefined(Colors.White),
        converter:const StringToColorConverter());
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

      if (stop != stops.value.last) {
        colorString.add(", ");
      }
    });

    //set the background for all browser types
    element.style.background = "-webkit-linear-gradient(${direction.value}, ${colorString})";
    element.style.background = "-moz-linear-gradient(${direction.value}, ${colorString})";
    element.style.background = "-ms-linear-gradient(${direction.value}, ${colorString})";
    element.style.background = "-o-linear-gradient(${direction.value}, ${colorString})";
    element.style.background = "linear-gradient(${direction.value}, ${colorString})";
  }
}
