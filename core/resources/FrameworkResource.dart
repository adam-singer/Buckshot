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
* Defines elements that can be used as resources within the framework.
*
* Framework resources are not visual elements, but instead define
* reusable content that can be assigned to visual element properties.
*
* In order for a framework resource to be used in Lucaxml, the [key]
* property must be defined. Resources keys should generally be unique,
* but uniqueness is not required by the framework.
*
* ## Lucaxml Example Usage
*     <resourcecollection>
*         <color value="#FF0000" key="redcolor"></color>
*         <solidcolorbrush key="redbrush" color={resource redcolor}"></solidcolorbrush>
*     </resourcecollection>
*     <panel background="{resource redbrush}"></panel>
*
* ## Core Framework Resources
* * [StyleTemplate]
* * [Color]
* * [SolidColorBrush]
* * [LinearGradientBrush]
* * [RadialGradientBrush]
* * [VarResource]
*/
class FrameworkResource extends FrameworkObject
{
  /// An application-wide unique identifier for the resource.
  /// Required.
  FrameworkProperty keyProperty;
  
  /// A meta-data tag that is used to identify the default resource
  /// property of a FrameworkResource.
  ///
  /// ### To set the resource property of an element:
  ///     stateBag[RESOURCE_PROPERTY] = {propertyNameOfElementResourceProperty};
  static final String RESOURCE_PROPERTY = "RESOURCE_PROPERTY";
  
  FrameworkResource(){
    _initFrameworkResourceProperties();
  }
  
  void _initFrameworkResourceProperties(){
    keyProperty = new FrameworkProperty(this, "key", (_){}, "");
  }
  
  /// Sets the [keyProperty] value.
  set key(String v) => setValue(keyProperty, v);
  /// Gets the [keyProperty] value.
  String get key() => getValue(keyProperty);
  
  String get _type() => "FrameworkResource";
}
