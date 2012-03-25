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
  
  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new LinearGradientBrush();
  
  LinearGradientBrush([LinearGradientDirection dir, Color fallback]) 
  {
    _initLinearGradientBrushProperties();
    
    if (dir != null) direction = dir;//LinearGradientDirection.horizontal;
    if (fallback != null) fallbackColor = fallback;// = new Color.predefined(Colors.White);
   
    this._stateBag[FrameworkObject.CONTAINER_CONTEXT] = stopsProperty;
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
    stopsProperty = new FrameworkProperty(this, "stops", (v){
    }, new List<GradientStop>());
    
    directionProperty = new FrameworkProperty(this, "direction", (v){      
    }, LinearGradientDirection.horizontal, converter:const StringToLinearGradientDirectionConverter());
    
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
    element.style.background = "-webkit-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "-moz-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "-ms-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "-o-linear-gradient(${direction.toString()}, ${colorString})";
    element.style.background = "linear-gradient(${direction.toString()}, ${colorString})";
    
  }
  
  String get type() => "LinearGradientBrush";
}
