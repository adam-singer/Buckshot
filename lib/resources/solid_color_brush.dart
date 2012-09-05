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
  FrameworkProperty colorProperty;

  SolidColorBrush([Color toColor]){

   _initSolidColorBrushProperties();

   if (toColor != null) color = toColor;
  }
  
  SolidColorBrush.register() : super.register();
  makeMe() => new SolidColorBrush();

  void _initSolidColorBrushProperties(){
    colorProperty = new FrameworkProperty(this, "color");
  }

  set color(Color c) => setValue(colorProperty, c);
  Color get color => getValue(colorProperty);

  void renderBrush(Element element){
    element.style.background = "${color}";
//    element.style.setProperty('fill', "${color}");
  }
}


