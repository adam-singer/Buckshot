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
  FrameworkProperty stopsProperty;
  /// Represents the [LinearGradientDirection] of the LinearGradientBrush.
  FrameworkProperty directionProperty;
  /// Represents the fall back [Color] to use if gradients aren't supported.
  FrameworkProperty fallbackColorProperty;

  LinearGradientBrush([LinearGradientDirection dir, Color fallback])
  {
    _initLinearGradientBrushProperties();

    if (dir != null) direction = dir;//LinearGradientDirection.horizontal;
    if (fallback != null) fallbackColor = fallback;// = new Color.predefined(Colors.White);

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = stopsProperty;
  }

  /// Sets the [stopsProperty] value.
  set stops(List<GradientStop> value) => setValue(stopsProperty, value);
  /// Gets the [stopsProperty] value.
  List<GradientStop> get stops() => getValue(stopsProperty);

  /// Sets the [directionProperty] value.
  set direction(LinearGradientDirection value) => setValue(directionProperty, value);
  /// Gets the [directionProperty] value.
  LinearGradientDirection get direction() => getValue(directionProperty);

  /// Sets the [fallbackColorProperty] value.
  set fallbackColor(Color value) => setValue(fallbackColorProperty, value);
  /// Gets the [fallbackColorProperty] value.
  Color get fallbackColor() => getValue(fallbackColorProperty);

  void _initLinearGradientBrushProperties(){
    stopsProperty = new FrameworkProperty(this, "stops",
        defaultValue:new List<GradientStop>());

    directionProperty = new FrameworkProperty(this, "direction",
        defaultValue:LinearGradientDirection.horizontal,
        converter:const StringToLinearGradientDirectionConverter());

    fallbackColorProperty = new FrameworkProperty(this, "fallbackColor",
        defaultValue:new Color.predefined(Colors.White),
        converter:const StringToColorConverter());
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

    element.style.background = "-webkit-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "-moz-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "-ms-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "-o-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "linear-gradient(${direction.toString()}, ${colorString})";

  }
}
