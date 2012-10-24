part of core_buckshotui_org;

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
  FrameworkProperty<Color> color;
  /// Represents the offset percentage of the GradientStop.
  FrameworkProperty<num> percent;

  GradientStop(){
    _initGradientStopProperties();
  }

  GradientStop.register() : super.register();
  makeMe() => new GradientStop();

  /// Constructs a GradientStop with a given [Color] and optional offset %.
  GradientStop.with(Color stopColor, [num stopPercent = -1]){
    _initGradientStopProperties();
    color.value = stopColor;
    percent.value = stopPercent;
  }

  void _initGradientStopProperties(){
    color = new FrameworkProperty(this, "color",
        converter:const StringToColorConverter());

    percent = new FrameworkProperty(this, "percent",
        defaultValue: -1,
        converter:const StringToNumericConverter());
  }
}
