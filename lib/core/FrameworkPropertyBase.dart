// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


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
  FrameworkPropertyBase(this.sourceObject, this.propertyName, callback, [this.stringToValueConverter = null]) :
   propertyChanging = new FrameworkEvent<PropertyChangingEventArgs>(),
   propertyChangedCallback = (callback == null ? (_){} : callback);

   String get type() => "FrameworkPropertyBase";

   String toString() => '(${sourceObject.type}) $propertyName';
}