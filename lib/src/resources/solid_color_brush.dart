part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents a brush with a single solid [Color].
* See:
* [LinearGradientBrush]
* [RadialGradientBrush]
 */
class SolidColorBrush extends Brush
{
  FrameworkProperty<Color> color;

  SolidColorBrush([Color toColor]){

   _initSolidColorBrushProperties();

   if (toColor != null) color.value = toColor;
  }

  SolidColorBrush.fromPredefined(Colors predefinedColor){
    _initSolidColorBrushProperties();

    color.value = new Color.predefined(predefinedColor);
  }

  SolidColorBrush.fromHex(String hexColor){
    _initSolidColorBrushProperties();

    color.value = new Color.hex(hexColor);
  }

  SolidColorBrush.fromRGB(int r, int g, int b){
    _initSolidColorBrushProperties();

    color.value = new Color.fromRGB(r, g, b);
  }


  SolidColorBrush.register() : super.register();
  makeMe() => new SolidColorBrush();

  void _initSolidColorBrushProperties(){
    color = new FrameworkProperty(this, "color");
  }

  void renderBrush(Element element){
    element.style.background = "${color.value.toColorString()}";
//    element.style.setProperty('fill', "${color}");
  }
}


