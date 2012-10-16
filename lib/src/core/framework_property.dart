// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Represents property of an element that participates in the framework
 * [Binding] model.
 *
 * ## Usage ##
 * ### Declare a FrameworkProperty as a field ###
 *     FrameworkProperty<num> foo;
 *
 * ### Initialize a FrameworkProperty (usually in constructor) ###
 *     foo = new FrameworkProperty(this, "foo",
 *             defaultValue: 123
 *             converter: const StringToNumericConverter());
 *     // Provide a string converter if the property type is not a String.
 *     // This provides better compatibility with Template parsing.
 *
 * ### Template usage ###
 *     <MyElement my="42"></MyElement>
 *
 * ## See Also ##
 * * [AttachedFrameworkProperty]
 */
class FrameworkProperty<T> extends FrameworkPropertyBase
{
  T _value;

  /**
   * Represents the stored value of the FrameworkProperty.
   *
   * Generally, this should not be access directly, but through:
   *     getValue({propertyName});
   */
   set value(T newValue){
     if (stringToValueConverter != null && newValue is String){
       newValue = stringToValueConverter.convert(newValue);
     }

     if (newValue == _value) return;

     previousValue = _value;
     _value = newValue;

     // 1) callback
     propertyChangedCallback(value);

     // 2) bindings
     Binding._executeBindingsFor(this);

     // 3) event
     if (propertyChanging.hasHandlers)
       propertyChanging.invokeAsync(sourceObject,
           new PropertyChangingEventArgs(previousValue, value));

   }

  T get value() => _value;

  T previousValue;

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
      T defaultValue = null,
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
class AnimatingFrameworkProperty<T> extends FrameworkProperty<T>
{
  final String cssPropertyPeer;

  AnimatingFrameworkProperty(FrameworkElement sourceObject, String propertyName, String this.cssPropertyPeer, [Function propertyChangedCallback, T defaultValue = null, converter = null])
  : super(sourceObject, propertyName, propertyChangedCallback, defaultValue:defaultValue, converter:converter)
  {
    if (sourceObject is! FrameworkElement) throw const BuckshotException('AnimatingFrameworkProperty can only be used with elements that derive from FrameworkElement.');
  }
}