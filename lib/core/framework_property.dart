// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


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
  Dynamic _value;

  /**
   * Represents the stored value of the FrameworkProperty.
   *
   * Generally, this should not be access directly, but through:
   *     getValue({propertyName});
   */
  Dynamic get value => _value;
  set value(Dynamic v) {
    if (readOnly){
      throw const BuckshotException('Attempted to write to a read-only property.');
    }
    _value = v;
  }

  /// Gets the previous value assigned to the FrameworkProperty.
  Dynamic get previousValue => _previousValue;
  Dynamic _previousValue;
  bool readOnly = false;

  /// Constructs a FrameworkProperty and initializes it to the framework.
  ///
  /// ### Parameters
  /// * [BuckshotObject] sourceObject - the object the property belongs to.
  /// * [String] propertyName - the friendly public name for the property.
  /// * [Function] propertyChangedCallback - called by the framework when the property value changes.
  /// * [Dynamic] value - optional default value assigned to the property at initialization.
  FrameworkProperty(
      BuckshotObject sourceObject,
      String propertyName,
      [Function propertyChangedCallback,
      defaultValue = null,
      converter = null])
  : super(
      sourceObject,
      propertyName,
      propertyChangedCallback,
      stringToValueConverter:converter)
  {

    if (!reflectionEnabled && sourceObject != null){
      sourceObject._frameworkProperties.add(this);
    }
    
    // If the value is provided, then call it's propertyChanged function to set the value on the property.
    if (defaultValue !== null){
      value = defaultValue;
      if (propertyChangedCallback != null) propertyChangedCallback(value);
      propertyChanging.invoke(this, new PropertyChangingEventArgs(null, value));
    }
  }
}

/// A [FrameworkProperty] that supports participation in transition/animation features.
class AnimatingFrameworkProperty extends FrameworkProperty{
  final String cssPropertyPeer;

  AnimatingFrameworkProperty(FrameworkElement sourceObject, String propertyName, Function propertyChangedCallback, String this.cssPropertyPeer, [value = null, converter = null])
  : super(sourceObject, propertyName, propertyChangedCallback, defaultValue:value, converter:converter)
  {
    if (sourceObject is! FrameworkElement) throw const BuckshotException('AnimatingFrameworkProperty can only be used with elements that derive from FrameworkElement.');
  }
}