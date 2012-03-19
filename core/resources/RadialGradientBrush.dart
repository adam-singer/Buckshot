//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

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
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new RadialGradientBrush();
  
  RadialGradientBrush([RadialGradientDrawMode mode, Color fallback])
  {
    _initRadialGradientProperties();
    
    if (fallback != null) fallbackColor = fallback;
    if (mode != null) drawMode = mode; 
  }
  
  /// Sets the [stopsProperty] value.
  set stops(List<GradientStop> value) => setValue(stopsProperty, value);
  /// Gets the [stopsProperty] value.
  List<GradientStop> get stops() => getValue(stopsProperty);
  
  /// Sets the [drawModeProperty] value.
  set drawMode(RadialGradientDrawMode value) => setValue(drawModeProperty, value);
  /// Gets the [drawModeProperty] value.
  RadialGradientDrawMode get drawMode() => getValue(drawModeProperty);
  
  /// Sets the [fallbackColorProperty] value.
  set fallbackColor(Color value) => setValue(fallbackColorProperty, value);
  /// Gets the [fallbackColorProperty] value.
  Color get fallbackColor() => getValue(fallbackColorProperty);
  
  
  void _initRadialGradientProperties(){
    stopsProperty = new FrameworkProperty(this, "stops", (v){
    }, new List<GradientStop>());
    
    drawModeProperty = new FrameworkProperty(this, "drawMode", (v){      
    }, RadialGradientDrawMode.contain);
    
    drawModeProperty.stringToValueConverter = const StringToRadialGradientDrawModeConverter();
    
    fallbackColorProperty = new FrameworkProperty(this, "fallbackColor", (v){},
      new Color.predefined(Colors.White));
  } 
  
  /// Overridden [Brush] method.
  void renderBrush(Element element){
    //set the fallback
    element.style.background = fallbackColor.toString();
    
    String colorString = "";
    
    //create the string of stop colors
    stops.forEach((GradientStop stop){
      colorString += stop.color.toString();

      if (stop.percent != -1)
        colorString += " ${stop.percent}%";
      
      if (stop != stops.last())
        colorString += ", ";
    });
    
    //set the background for all browser types
    element.style.background = "-webkit-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "-moz-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "-ms-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "-o-radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
    element.style.background = "radial-gradient(50% 50%, ${drawMode.toString()}, ${colorString})";
  }
  
  String get type() => "RadialGradientBrush";
}
