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
* Base class for framework property types.
*
* ## See Also
* * [FrameworkProperty]
* * [AttachedFrameworkProperty] 
*/
class FrameworkPropertyBase extends HashableObject{
  /// Holds a reference to the object that the property belongs to.
  final BuckshotObject sourceObject;
  /// Holds a callback function that is invoked whenever the value
  /// of a property changes.
  final Function propertyChangedCallback;
  /// Holds the friendly name of the property.
  final String propertyName;
  /// Fires when the property value changes.
  final FrameworkEvent<PropertyChangingEventArgs> propertyChanging;
  /// Holds a converter that is used to convert strings into the type
  /// Required by the property.
  final IValueConverter stringToValueConverter;
  
  /// Constructs a FrameworkPropertyBase and initializes it to the framework.
  ///
  /// ### Parameters
  /// * [LucaObject] sourceObject - the object the property belongs to.
  /// * [String] propertyName - the friendly public name for the property.
  /// * [Function] propertyChangedCallback - called by the framework when the property value changes.
  FrameworkPropertyBase(this.sourceObject, this.propertyName, this.propertyChangedCallback, [this.stringToValueConverter = null]) :
   propertyChanging = new FrameworkEvent<PropertyChangingEventArgs>(){}

   String get type() => "FrameworkPropertyBase";
   
   String toString() => '(${sourceObject.type}) $propertyName';
}