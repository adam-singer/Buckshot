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
* Represents a setter/value pair for a [FrameworkProperty].
*/
class StyleSetter extends BuckshotObject
{
  FrameworkProperty valueProperty, propertyProperty;
  
  BuckshotObject makeMe() => new StyleSetter();
  
  StyleSetter(){
    _initStyleSetterProperties();
  }
  
  StyleSetter.with(String propertyName, Dynamic propertyValue)
  {
    _initStyleSetterProperties();
    property = propertyName;
    value = propertyValue;
  }

  Dynamic get value() => getValue(valueProperty);
  set value(Dynamic newValue) => setValue(valueProperty, newValue);
  
  String get property() => getValue(propertyProperty);
  set property(String v) => setValue(propertyProperty, v);
  
  void _initStyleSetterProperties(){
    valueProperty = new FrameworkProperty(this, "value", (v){});
    
    propertyProperty = new FrameworkProperty(this, "property", (String v){});
  }
  
  String get type() => "StyleSetter";
}
