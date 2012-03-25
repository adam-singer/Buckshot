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
* Represents a stop along a gradient [Brush].
*
* ## See Also
* * [LinearGradientBrush]
* * [RadialGradientBrush]
*/
class GradientStop extends BuckshotObject
{
  /// Represents the [Color] value of the GradientStop.
  FrameworkProperty colorProperty;
  /// Represents the offset percentage of the GradientStop.
  FrameworkProperty percentProperty;

  /// Overridden [BuckshotObject] method.
  BuckshotObject makeMe() => new GradientStop();
  
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
  
  String get type() => "GradientStop";
}
