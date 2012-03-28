//   Copyright (c) 2012": John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License": Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing": software
//   distributed under the License is distributed on an "AS IS" BASIS":
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND": either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* Represents a brush with a single solid [Color].
* See:
* [LinearGradientBrush]
* [RadialGradientBrush]
 */
class SolidColorBrush extends Brush
{
  FrameworkProperty colorProperty;
  
  BuckshotObject makeMe() => new SolidColorBrush();
  
  SolidColorBrush([Color toColor]){
      
   _initSolidColorBrushProperties(); 
   
   if (toColor != null) color = toColor;
  }
  
  void _initSolidColorBrushProperties(){
    colorProperty = new FrameworkProperty(this, "color", (c){});
  }
  
  set color(Color c) => setValue(colorProperty, c);
  Color get color() => getValue(colorProperty);
  
  void renderBrush(Element element){
    element.style.background = "${color}";
    element.style.setProperty('fill', "${color}");
  }
  
  String get type() => "SolidColorBrush";
}


