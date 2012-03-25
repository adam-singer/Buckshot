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
 * Represents property of an element that participates in the framework [Binding] model.
 *
 * ## Usage
 * ### Declare a FrameworkProperty as a field:
 *     FrameworkProperty myProperty; //always use 'Property' suffix by convention
 *
 * ### Initialize a FrameworkProperty (usually in constructor):
 *     myProperty = new FrameworkProperty(this, "my", (num v){}, 123);
 *     // Provide a string converter if the property type is not a String.
 *     // This provides better compatibility with Lucaxml parsing.
 *     myProperty.stringToValueConverter = const StringToNumericConverter();
 *
 * ### Provide public getter/setter for convenient in-code access.
 *     String get my() => getValue(myProperty);
 *     set my(num value) => setValue(myProperty, value);
 *
 * ### Lucaxml usage:
 *     <MyElement my="42"></MyElement>
 *
 * ## See Also
 * * [AttachedFrameworkProperty]
 */
class FrameworkProperty extends FrameworkPropertyBase
{
  /// Represents the stored value of the FrameworkProperty.
  ///
  /// Generally, this should not be access directly, but through:
  ///     getValue({propertyName});
  Dynamic value = null;
 
  
  /// Gets the previous value assigned to the FrameworkProperty.
  Dynamic get previousValue() => _previousValue;
  Dynamic _previousValue;
    
  /// Constructs a FrameworkProperty and initializes it to the framework.
  ///
  /// ### Parameters
  /// * [BuckshotObject] sourceObject - the object the property belongs to.
  /// * [String] propertyName - the friendly public name for the property.
  /// * [Function] propertyChangedCallback - called by the framework when the property value changes.
  /// * [Dynamic] value - optional default value assigned to the property at initialization.
  FrameworkProperty(BuckshotObject sourceObject, String propertyName, Function propertyChangedCallback, [this.value = null, converter = null])
  : super(sourceObject, propertyName, propertyChangedCallback, stringToValueConverter:converter)
  {

    if (this.sourceObject != null)
      this.sourceObject._frameworkProperties.add(this);
    
    if (propertyChangedCallback == null) propertyChangedCallback = (v) {};
    
    // If the value is provided, then call it's propertyChanged function to set the value on the property.
    if (value !== null){
      propertyChangedCallback(value);
      propertyChanging.invoke(this, new PropertyChangingEventArgs(null, value));
    }
    
  }
   
  String get type() => "FrameworkProperty";
}

/// A [FrameworkProperty] that supports transition/animation features.
class AnimationFrameworkProperty extends FrameworkProperty{
  final Function _transitionFunc;
  
  AnimationFrameworkProperty(FrameworkElement sourceObject, String propertyName, Function propertyChangedCallback, Function this._transitionFunc, [value = null])
  : super(sourceObject, propertyName, propertyChangedCallback, value:value)
  {
    if (sourceObject is! FrameworkElement) throw const FrameworkException('AnimationFrameworkProperties can only be used with elements that derive from FrameworkElement.');
  }
  
  setTransition(BuckshotTransition transition) => _transitionFunc(transition);
  
  String get type() => "AnimationFrameworkProperty";
  
}