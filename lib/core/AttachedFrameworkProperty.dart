// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Represents a property of an element that can be attached loosely to other
 * elements.
 *
 * Note that attached properties do not participate in the data binding model
 * (they cannot bind or be bound to).
 */
class AttachedFrameworkProperty extends FrameworkPropertyBase
{
  static HashMap<AttachedFrameworkProperty, HashMap<FrameworkObject,
  Dynamic>> _attachedProperties;

  AttachedFrameworkProperty(String propertyName,
      Function propertyChangedCallback)
    : super(null, propertyName, propertyChangedCallback)
    {
      if (_attachedProperties == null){
        _attachedProperties = new HashMap<AttachedFrameworkProperty,
        HashMap<FrameworkObject, Dynamic>>();
      }

      _attachedProperties[this] =
          new HashMap<FrameworkElement, Dynamic>();
    }

  /**
   * Returns the setter function of a given [classPropertyPair] where the
   * string looks like:
   *
   *     'class.attachedPropertyName'
   *
   * NOT WORKING (see inner comments)
   */
  static void invokeSetPropertyFunction(String classPropertyPair, element, value){
    final split = classPropertyPair.split('.');
    final classMirror = buckshot.miriam.getObjectByName(split[0]);

    var setterMethodName;

    classMirror
    .methods
    .getKeys()
    .some((k){
      if (k.toLowerCase() == 'set${split[1]}'){
        setterMethodName = k;
        return true;
      }
      return false;
    });

    if (setterMethodName == null){
      throw new BuckshotException('Attached property $classPropertyPair not found.');
    }


    //TODO Fails because .invoke() doesn't support complex types as arguments...
    classMirror.invoke(setterMethodName, [element, value]);

  }

  /**
   * Sets the value of a given [AttachedFrameworkProperty] for a given
   * Element.
   */
  static void setValue(FrameworkElement element,
                               AttachedFrameworkProperty property,
                               value)
  {
    final aDepInfo = _attachedProperties[property];

    //no need to invoke if nothing has changed
    if (aDepInfo[element] == value) return;

    Dynamic oldValue = aDepInfo[element];
    aDepInfo[element] = value;

    //invoke the event so that any subscribers will get the message
    //subscribers will typically be parents interested to know if attached
    // properties change on children
    element.attachedPropertyChanged.invoke(element,
        new AttachedPropertyChangedEventArgs(element, property, value));

    property.propertyChanging.invoke(property,
        new PropertyChangingEventArgs(oldValue, value));
  }

  /**
   * Gets the value of a given [AttachedFrameworkProperty] for a given
   * Element.
   */
  static getValue(FrameworkElement element,
                                  AttachedFrameworkProperty property){
    if (property == null) return null;

    final aDepInfo = _attachedProperties[property];

    return (aDepInfo.containsKey(element)) ? aDepInfo[element] : null;
  }
}