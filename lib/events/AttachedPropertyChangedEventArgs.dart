// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Represents information passed by the propertyChanged [FrameworkEvent] of the [AttachedFrameworkProperty]. */
class AttachedPropertyChangedEventArgs extends EventArgs
{
  /// Reference to the attached property source.
  final property;
  
  /// Reference to the element that the property is attached to.
  final element;
  
  /// Holds the value assigned to the attached property.
  final Dynamic value;
  
  AttachedPropertyChangedEventArgs(this.element, this.property, this.value);
  
  String get _type() => "AttachedPropertyChangedEventArgs";
}