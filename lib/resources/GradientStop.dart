// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a stop along a gradient [Brush].
*
* ## See Also
* * [LinearGradientBrush]
* * [RadialGradientBrush]
*/
class GradientStop extends TemplateObject
{
  /// Represents the [Color] value of the GradientStop.
  FrameworkProperty colorProperty;
  /// Represents the offset percentage of the GradientStop.
  FrameworkProperty percentProperty;

  GradientStop(){
    _initGradientStopProperties();
  }

  /// Constructs a GradientStop with a given [Color] and optional offset %.
  GradientStop.with(Color stopColor, [int stopPercent = -1]){
    _initGradientStopProperties();
    color = stopColor;
    percent = stopPercent;
  }

  /// Sets the [colorProperty] value.
  set color(Color value) => setValue(colorProperty, value);
  /// Gets the [colorProperty] value.
  Color get color() => getValue(colorProperty);

  /// Sets the [percentProperty] value.
  set percent(int value) => setValue(percentProperty, value);
  /// Gets the [percentProperty] value.
  int get percent() => getValue(percentProperty);

  void _initGradientStopProperties(){
    colorProperty = new FrameworkProperty(this, "color", (v){}, converter:const StringToColorConverter());

    percentProperty = new FrameworkProperty(this, "percent", (v){}, -1, converter:const StringToNumericConverter());
  }
}
